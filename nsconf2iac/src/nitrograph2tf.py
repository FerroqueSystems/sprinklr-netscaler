import utils
import random
import logging

from nitro_resource_map import NITRO_RESOURCE_MAP
from supported_resources import SUPPORTED_RESOURCES

PRIMARY_KEY_MAP = {
    r: NITRO_RESOURCE_MAP[r]["primary_key"] for r in NITRO_RESOURCE_MAP.keys()
}
BIND_PRIMARY_KEY_MAP = {
    r: NITRO_RESOURCE_MAP[r]["bindprimary_key"] for r in NITRO_RESOURCE_MAP.keys()
}
unsupported_resources = []


def processthebinding(data, tfjson, verbose=False):
    for resource_name in data:
        if (resource_name != "resources" and resource_name.endswith("_binding") and "global_" not in resource_name):
            if resource_name not in SUPPORTED_RESOURCES:
                if verbose:
                    logging.info(f"Skipping {resource_name}")
                unsupported_resources.append(resource_name)
                continue

            if resource_name == "sslprofile_ecccurve_binding":
                process_sslprofile_ecccurve_binding(data, tfjson, resource_name, verbose)
            else:
                process_binding(data, tfjson, resource_name, verbose)

    process_global_bindings(data, tfjson, verbose)
    return tfjson


def process_sslprofile_ecccurve_binding(data, tfjson, resource_name, verbose):
    sslprofile_name_old = data[resource_name][0]["properties"]["name"]
    ecccurvebinding = []
    lastindex_ecccurvebinding = len(data[resource_name]) - 1

    for ref_index, resource in enumerate(data[resource_name]):
        if verbose:
            logging.info(f"Processing {resource_name} at index {ref_index}")

        attrs = resource["properties"]
        bind_entity1, bind_entity2, _ = resource_name.split("_")

        if "primary_key" in attrs:
            attrs.pop("primary_key")
        if "resourceid" in attrs:
            attrs.pop("resourceid")

        sslprofile_name = resource["properties"]["name"]
        if (sslprofile_name_old == sslprofile_name and lastindex_ecccurvebinding != ref_index):
            ecccurvebinding.append(attrs["ecccurvename"])
            continue
        else:
            rid = utils.sanitize(f"{sslprofile_name_old}_ecccurve")
            full_resource_name = "citrixadc_sslprofile_ecccurve_binding"
            if full_resource_name not in tfjson["resource"]:
                tfjson["resource"][full_resource_name] = {}
            ecccurve_attrs = {
                "ecccurvename": ecccurvebinding,
                "name": sslprofile_name_old,
                "remove_existing_ecccurve_binding": "true",
            }
            depends_on = [f"citrixadc_{bind_entity1}.{utils.sanitize(sslprofile_name_old)}"]
            ecccurve_attrs.update({"depends_on": depends_on})

            tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, ecccurve_attrs))
            ecccurvebinding = [attrs["ecccurvename"]]
            sslprofile_name_old = sslprofile_name


def process_binding(data, tfjson, resource_name, verbose):
    for ref_index, resource in enumerate(data[resource_name]):
        attrs = resource["properties"]
        bind_entity1, bind_entity2, _ = resource_name.split("_")

        if "primary_key" in attrs:
            attrs.pop("primary_key")
        if "resourceid" in attrs:
            attrs.pop("resourceid")

        entity1_id = attrs[PRIMARY_KEY_MAP[bind_entity1]]
        entity2_id = get_entity2_id(attrs, resource_name, bind_entity2)

        rid = utils.sanitize(f"{entity1_id}_{entity2_id}_{ref_index}")
        if verbose:
            logging.info(f"{resource_name=}; {rid=}")
        full_resource_name = "citrixadc_" + resource_name
        depends_on = [f"citrixadc_{bind_entity1}.{utils.sanitize(entity1_id)}"]

        if resource_name == "vlan_nsip_binding":
            attrs.update({"vlanid": attrs["id"]})
            attrs.pop("id")
        elif resource_name == "vlan_interface_binding":
            attrs.update({"vlanid": attrs["id"]})
            attrs.pop("id")
        elif resource_name == "servicegroup_lbmonitor_binding":
            attrs.update({"monitorname": attrs.pop("monitor_name")})
        elif resource_name == "lbvserver_servicegroup_binding":
            attrs.update({"servicegroupname": attrs.pop("servicename")})

        if bind_entity2 in data:
            for i in data[bind_entity2]:
                if bind_entity2 == "interface":
                    if "id" in i["properties"] and i["properties"]["id"] == entity2_id:
                        depends_on.append(f"citrixadc_{bind_entity2}.{utils.sanitize(entity2_id)}")
                        break
                elif (PRIMARY_KEY_MAP[bind_entity2] in i["properties"] and i["properties"][PRIMARY_KEY_MAP[bind_entity2]] == entity2_id):
                    depends_on.append(f"citrixadc_{bind_entity2}.{utils.sanitize(entity2_id)}")
                    break

        if verbose:
            logging.info(f"{depends_on=}")

        attrs.update({"depends_on": depends_on})

        if full_resource_name not in tfjson["resource"]:
            tfjson["resource"][full_resource_name] = {}

        if resource_name == "ipset_nsip_binding":
            for i in attrs["ipaddress"]:
                updated_attrs = attrs.copy()
                updated_attrs["ipaddress"] = i
                tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid + utils.sanitize("_" + i), updated_attrs))
        else:
            tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, attrs))


def get_entity2_id(attrs, resource_name, bind_entity2):
    try:
        entity2_id_attr = attrs[BIND_PRIMARY_KEY_MAP[resource_name]]
        if isinstance(entity2_id_attr, list):
            return entity2_id_attr[0]
        if entity2_id_attr == "":
            return utils.sanitize(bind_entity2)
        if resource_name == "botprofile_ratelimit_binding":
            return attrs["bot_rate_limit_type"]
        if resource_name == "botprofile_ipreputation_binding":
            return attrs["category"]
        return attrs[BIND_PRIMARY_KEY_MAP[resource_name]]
    except KeyError:
        return utils.sanitize(bind_entity2)


def process_global_bindings(data, tfjson, verbose):
    for global_resource_name in data:
        if (global_resource_name.endswith("_binding") and "global_" in global_resource_name):
            if global_resource_name not in SUPPORTED_RESOURCES:
                if verbose:
                    logging.info(f"Skipping {global_resource_name}")
                unsupported_resources.append(global_resource_name)
                continue

            _, bind_entity2, _ = global_resource_name.split("_")
            for ref_index, ref_bind_data in enumerate(data[global_resource_name]):
                attrs = data[global_resource_name][ref_index]["properties"]
                try:
                    entity2_id = utils.sanitize(attrs[BIND_PRIMARY_KEY_MAP[global_resource_name]])
                except KeyError:
                    entity2_id = utils.sanitize(bind_entity2)

                rid = utils.sanitize(f"{global_resource_name}_{ref_index}")
                if verbose:
                    logging.info(f"{global_resource_name=}; {rid=}")
                full_resource_name = "citrixadc_" + global_resource_name
                depends_on = []
                if "citrixadc_" + bind_entity2 in tfjson["resource"]:
                    depends_on.append(f"citrixadc_{bind_entity2}.{entity2_id}")

                if verbose:
                    logging.info(f"{depends_on=}")

                if depends_on:
                    attrs.update({"depends_on": depends_on})

                if full_resource_name not in tfjson["resource"]:
                    tfjson["resource"][full_resource_name] = {}
                tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, attrs))


# The following function is used to construct the provider block in the Terraform configuration
def construct_provider_block():
    terraform_config = """
terraform {
    required_providers {
        citrixadc = {
        source = "citrix/citrixadc"
        }
    }
}

provider "citrixadc" {
    endpoint = "http://<NSIP>"
    username = "nsroot"
    password = "<PASSWORD>"
}
    """

    with open("provider.tf", "w") as file:
        file.write(terraform_config)


def individual_resource_to_tfjson(data, verbose=False):
    tfjson = {
        "resource": {},
    }
    for resource_name in data:
        if resource_name != "resources" and not resource_name.endswith("_binding"):
            if resource_name not in SUPPORTED_RESOURCES and resource_name != "nsconfig":
                if verbose:
                    logging.info(f"Skipping {resource_name}")
                unsupported_resources.append(resource_name)
                continue
            for resource in data[resource_name]:
                attrs = resource["properties"]
                try:
                    if not isinstance(attrs[PRIMARY_KEY_MAP[resource_name]], str):
                        rid = utils.sanitize((attrs[PRIMARY_KEY_MAP[resource_name]])[0])
                    else:
                        rid = utils.sanitize(attrs[PRIMARY_KEY_MAP[resource_name]])
                except KeyError:
                    rid = resource_name + "_" + str(random.randint(1, 99999999))
                if verbose:
                    logging.info(f"{resource_name=}; {rid=}")
                if resource_name != "nsconfig":
                    full_resource_name = "citrixadc_" + resource_name
                else:
                    full_resource_name = "citrixadc_nsconfig_update"

                if full_resource_name not in tfjson["resource"]:
                    tfjson["resource"][full_resource_name] = {}

                if resource_name == "dnsaddrec":
                    attrs = utils.filter_readonly(attrs, resource_name)
                    for i in attrs["ipaddress"]:
                        updated_attrs = attrs.copy()
                        updated_attrs["ipaddress"] = i
                        tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid + utils.sanitize("_" + i), updated_attrs))
                elif resource_name == "interface":
                    updated_attrs = attrs.copy()
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    updated_attrs.update({"interface_id": updated_attrs["id"]})
                    updated_attrs.pop("id")
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "service" and "gslb" in attrs:
                    updated_attrs = attrs.copy()
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "vlan":
                    updated_attrs = attrs.copy()
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    updated_attrs.update({"vlanid": updated_attrs["id"]})
                    updated_attrs.pop("id")
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "hanode" and "id" in attrs:
                    updated_attrs = attrs.copy()
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    updated_attrs.update({"hanode_id": updated_attrs["id"]})
                    updated_attrs.pop("id")
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "locationfile":
                    updated_attrs = attrs.copy()
                    updated_attrs.update({"locationfile": updated_attrs["location_file"]})
                    updated_attrs.pop("location_file")
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "snmptrap":
                    attrs = utils.filter_readonly(attrs, resource_name)
                    for i in attrs["trapdestination"]:
                        updated_attrs = attrs.copy()
                        updated_attrs["trapdestination"] = i
                        tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid + utils.sanitize("_" + i), updated_attrs))
                elif resource_name == "nsfeature":
                    updated_attrs = attrs.copy()
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    for i in attrs["feature"]:
                        updated_attrs.update({i.lower(): "true"})
                    updated_attrs.pop("feature")
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "nsmode":
                    updated_attrs = attrs.copy()
                    updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
                    for i in attrs["mode"]:
                        updated_attrs.update({i.lower(): "true"})
                    updated_attrs.pop("mode")
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                elif resource_name == "nspbrs":
                    updated_attrs = attrs.copy()
                    updated_attrs.update({"action": updated_attrs.pop("nitro_operation")})
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, updated_attrs))
                else:
                    if "nitro_operation" in attrs:
                        # delete the nitro_operation key
                        attrs.update({"#nitro_operation": attrs["nitro_operation"]})
                        attrs.pop("nitro_operation")

                    if resource_name == "dnsnsrec":
                        rid = utils.sanitize(attrs["domain"] + "_" + attrs["nameserver"])
                    attrs = utils.filter_readonly(attrs, resource_name)
                    tfjson["resource"][full_resource_name].update(utils.construct_resource_block(rid, attrs))
                depends_on = []
                if resource_name == "sslvserver":
                    sslvserver_key = attrs["vservername"]
                    vservers = [
                        "lbvserver",
                        "csvserver",
                        "gslbvserver",
                        "vpnvserver",
                        "authenticationvserver",
                        "crvserver",
                    ]
                    for vserver in vservers:
                        if vserver in data:
                            for i in data[vserver]:
                                if (PRIMARY_KEY_MAP[vserver] in i["properties"] and i["properties"][PRIMARY_KEY_MAP[vserver]]== sslvserver_key):
                                    depends_on.append(f"citrixadc_{vserver}.{utils.sanitize(sslvserver_key)}")
                                    break

                elif resource_name == "sslservice":
                    sslservice_key = attrs["servicename"]
                    services = ["service", "gslbservice"]
                    for service in services:
                        if service in data:
                            for i in data[service]:
                                if (PRIMARY_KEY_MAP[service] in i["properties"] and i["properties"][PRIMARY_KEY_MAP[service]]== sslservice_key):
                                    depends_on.append(f"citrixadc_{service}.{utils.sanitize(sslservice_key)}")
                                    break

                if "references" in resource:
                    for bind_resource_type_name, bind_resource_type_data in resource["references"].items():
                        for rr in bind_resource_type_data:
                            # process the dependent resources
                            if not bind_resource_type_name.endswith("_binding"):
                                if ("is_argumentassociation" in rr and rr["is_argumentassociation"] is True):
                                    if "index" in rr:
                                        if bind_resource_type_name not in ["sslvserver", "sslservice"]:
                                            entity_index = rr["index"]
                                            entity_attrs = data[bind_resource_type_name][entity_index]["properties"]
                                            entity_id = entity_attrs[PRIMARY_KEY_MAP[bind_resource_type_name]]
                                            entity_id = utils.sanitize(entity_id)
                                            depends_on.append(f"citrixadc_{bind_resource_type_name}.{entity_id}")
                                if depends_on:
                                    tfjson["resource"][full_resource_name][rid].update({"depends_on": depends_on})

    return tfjson


# The following function is used to convert the Nitrograph data to Terraform format
def convert_nitrograph_to_tf(nitrograph_data, output_file, verbose=False):
    tfjson = nsconfjson_to_tfjson(nitrograph_data, verbose)
    utils.tfjson2tf(tfjson, output_file=output_file)
    construct_provider_block()


# The following function is used to convert the Nitrograph data to Terraform format
def nsconfjson_to_tfjson(data, verbose=False):
    tfjson = individual_resource_to_tfjson(data, verbose)
    processthebinding(data, tfjson, verbose)

    if unsupported_resources:
        # write unsupported_resources in a log file
        with open("unsupported_resources.log", "w") as f:
            f.write("The following resources are not supported by our terraform provider citrixADC yet:\n\n")
            f.write("\n".join(unsupported_resources))

    return tfjson
