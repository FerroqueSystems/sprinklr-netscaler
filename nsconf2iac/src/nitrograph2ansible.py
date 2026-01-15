import os
import utils
import random
import yaml
import json
from collections import OrderedDict
import logging

from nitro_resource_map import NITRO_RESOURCE_MAP
from supported_resources_ansible import SUPPORTED_RESOURCES_ANSIBLE

# The 'bind_primary_key' for 'botprofile_bindings' resources is of type "bool",
# which can cause generated resource IDs (rid) to overwrite other bindings of the same instance.
# To avoid this collision, this map uses an alternative unique key available in each resource.

botprofile_exception_list = {
	"botprofile_blacklist_binding": "bot_blacklist_value",
	"botprofile_captcha_binding": "bot_captcha_url",
	"botprofile_ipreputation_binding": "category",
	"botprofile_kmdetectionexpr_binding": "bot_km_expression_name",
	"botprofile_logexpression_binding": "bot_log_expression_name",
	"botprofile_ratelimit_binding": "bot_rate_limit_type",
	"botprofile_tps_binding": "bot_tps_type",
	"botprofile_trapinsertionurl_binding": "bot_trap_url",
	"botprofile_whitelist_binding": "bot_whitelist_value"
}
PRIMARY_KEY_MAP = {
    r: NITRO_RESOURCE_MAP[r]["primary_key"] for r in NITRO_RESOURCE_MAP.keys()
}
BIND_PRIMARY_KEY_MAP = {
    r: NITRO_RESOURCE_MAP[r]["bindprimary_key"] for r in NITRO_RESOURCE_MAP.keys()
}

class CustomDumper(yaml.SafeDumper):
    def ignore_aliases(self, data):
        return True

    def increase_indent(self, flow=False, indentless=False):
        return super(CustomDumper, self).increase_indent(flow, False)
    
    def represent_dict(self, data):
        return self.represent_mapping('tag:yaml.org,2002:map', {k.lower(): str(v) for k, v in data.items()})

def represent_custom_object(dumper, data):
    try:
        return dumper.represent_dict(data.__dict__)
    except AttributeError:
        raise yaml.representer.RepresenterError("cannot represent an object", data)

# Register the custom representer
CustomDumper.add_representer(object, represent_custom_object)

def construct_inventory_file():
    ansible_inventory = """
[demo_netscalers]
demo_netscaler1

[demo_netscalers:vars]
nsip= <netscaler_ip>
nitro_user= <username>
nitro_pass= <password>
nitro_protocol= http
validate_certs= no
    """
    with open("inventory.ini", "w") as file:
        file.write(ansible_inventory)

def nsconfjson_to_ansiblejson(data, verbose=False):
	unsupported_resources = []
	unsupported_operations = []
	ansiblejson = {"resource": {}}
	for resource_name in data:
		if resource_name == "resource" or resource_name == "resources":
			continue
		if resource_name not in SUPPORTED_RESOURCES_ANSIBLE and resource_name != "nsconfig":
			if verbose:
				print(f"Skipping {resource_name}")
			unsupported_resources.append(resource_name)
			continue
		for resource in data[resource_name]:
			created = False
			attrs = resource["properties"]
			if attrs.get('nitro_operation') in unsupported_operations:
				continue
			try:
				rid = utils.sanitize(attrs[PRIMARY_KEY_MAP[resource_name]][0] if not isinstance(attrs[PRIMARY_KEY_MAP[resource_name]], str) else attrs[PRIMARY_KEY_MAP[resource_name]])
				if resource_name.endswith("_binding"):
					if botprofile_exception_list.get(resource_name):
						rid += utils.sanitize(attrs[botprofile_exception_list[resource_name]])
					else:
						rid += '_' + utils.sanitize(attrs[BIND_PRIMARY_KEY_MAP[resource_name]][0] if not isinstance(attrs[BIND_PRIMARY_KEY_MAP[resource_name]], str) else attrs[BIND_PRIMARY_KEY_MAP[resource_name]])
					if attrs.get('bindpoint'):
						rid += '_' + utils.sanitize(attrs['bindpoint'])
			except KeyError:
				rid = str(random.randint(1, 99999999))
			
			if verbose:
				logging.info(f"{resource_name=}; {rid=}")
				
			module_name = "netscaler.adc." + resource_name
			full_resource_name = resource_name + "_" + rid
			nitro_op = attrs.get("nitro_operation", "present")
			if resource_name == "dnsaddrec":
				created = True
				for i in attrs["ipaddress"]:
					updated_attrs = attrs.copy()
					updated_attrs["ipaddress"] = i
					updated_full_resource_name = full_resource_name + "_" + i
					if updated_full_resource_name not in ansiblejson["resource"]:
						ansiblejson["resource"][updated_full_resource_name] = {}
					task = utils.construct_ansible_task_block(updated_full_resource_name, module_name, nitro_op)
					if task is not None:
						updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
						task[module_name].update(updated_attrs)
						ansiblejson["resource"][updated_full_resource_name].update(task)
					else:
						if nitro_op not in unsupported_operations:
							unsupported_operations.append(nitro_op)
					
			elif resource_name == "snmptrap":
				created = True
				for i in attrs["trapdestination"]:
					updated_attrs = attrs.copy()
					updated_attrs["trapdestination"] = i
					updated_full_resource_name = full_resource_name + "_" + i
					if updated_full_resource_name not in ansiblejson["resource"]:
						ansiblejson["resource"][updated_full_resource_name] = {}
					task = utils.construct_ansible_task_block(updated_full_resource_name, module_name, nitro_op)
					if task is not None:
						updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
						task[module_name].update(updated_attrs)
						ansiblejson["resource"][updated_full_resource_name].update(task)
					else:
						if nitro_op not in unsupported_operations:
							unsupported_operations.append(nitro_op)

			elif resource_name == "locationfile":
				updated_attrs = attrs.copy()
				if "Locationfile" in updated_attrs:
					updated_attrs.update({"locationfile": updated_attrs.pop("Locationfile")})
				if "location_file" in updated_attrs:
					updated_attrs.update({"locationfile": updated_attrs.pop("location_file")})

			elif resource_name == "servicegroup_lbmonitor_binding":
				updated_attrs = attrs.copy()
				updated_attrs.update({"monitorname": updated_attrs.pop("monitor_name")})

			elif resource_name == "lbvserver_servicegroup_binding":
				updated_attrs = attrs.copy()
				updated_attrs.update({"servicegroupname": updated_attrs.pop("servicename")})

			elif resource_name == "nsfeature":
				updated_attrs = attrs.copy()
				for i in attrs["feature"]:
					updated_attrs.update({i.lower(): "true"})
				updated_attrs.pop("feature")
				
			elif resource_name == "nsmode":
				updated_attrs = attrs.copy()
				for i in attrs["mode"]:
					updated_attrs.update({i.lower(): "true"})
				updated_attrs.pop("mode")
				
			elif resource_name == "nspbrs":
				updated_attrs = attrs.copy()
				updated_attrs.update({"action": updated_attrs.pop("nitro_operation")})

			elif resource_name == "dnsnsrec":
				rid = utils.sanitize(attrs["domain"] + "_" + attrs["nameserver"])
				full_resource_name = resource_name + "_" + rid
			elif resource_name == "ptp":
				attrs.pop("state")
			if not created and resource_name != "ptp":
				if 'updated_attrs' in locals():
					if len(updated_attrs) == 0:
						unsupported_resources.append(resource_name)
						del attrs
						del updated_attrs
						continue
				if len(attrs) == 0:
					unsupported_resources.append(resource_name)
					del attrs
					continue
				if full_resource_name not in ansiblejson["resource"]:
					ansiblejson["resource"][full_resource_name] = {}
				task = utils.construct_ansible_task_block(full_resource_name, module_name, nitro_op)
				if task is not None:
        			# nspbrs do not have readonly attributes in nitro_resource_map
					# nsfeature and nsmode have 'feature' and 'mode' attributes respectively which are required during create operation
					# so skipping filter_readonly for nspbrs, nsfeature and nsmode
					if resource_name not in ["nspbrs", "nsfeature", "nsmode"]:
						if 'updated_attrs' in locals():
							updated_attrs = utils.filter_readonly(updated_attrs, resource_name)
						else:
							attrs = utils.filter_readonly(attrs, resource_name)
					else:
						if 'updated_attrs' in locals():
							updated_attrs.pop("nitro_operation", None)
						else:
							attrs.pop("nitro_operation", None)

					task[module_name].update(updated_attrs if 'updated_attrs' in locals() else attrs)
					ansiblejson["resource"][full_resource_name].update(task)
				else:
					if nitro_op not in unsupported_operations:
						unsupported_operations.append(nitro_op)
			
			del attrs
			if 'updated_attrs' in locals(): del updated_attrs

	if unsupported_resources:
		with open("unsupported_resources.log", "w") as f:
			f.write("The following resources are not supported by ansible modules yet:\n")
			f.write("\n".join(unsupported_resources))
	if unsupported_operations:
		with open("unsupported_operations.log", "w") as f:
			f.write("The following operations are not supported by ansible modules yet:\n")
			f.write("\n".join(unsupported_operations))

	return ansiblejson["resource"].values()

def ansiblejson2ansibleplaybook(ansiblejson, output_file):
    playbook = [
        {
            "name": "ns.conf playbook",
            "hosts": "demo_netscalers",
            "gather_facts": False,
            "tasks": list(ansiblejson),
        }
    ]

    with open(output_file, "w") as file:
        file.write('---\n')  # Add the '---' line at the beginning
        yaml.dump(playbook, file, Dumper=CustomDumper, sort_keys=False)

def convert_nitrograph_to_ansible(nitrograph_data, output_file, verbose=False):
    ansiblejson = nsconfjson_to_ansiblejson(nitrograph_data, verbose=verbose)
    with open("nitrograph.json", 'w') as file:
        file.write(yaml.dump(nitrograph_data, Dumper=CustomDumper, sort_keys=False))
    with open("ansible.json", 'w') as file:
        file.write(json.dumps(list(ansiblejson), indent=2))  # Convert dict_values to list
    ansiblejson2ansibleplaybook(ansiblejson, output_file)
    construct_inventory_file()
    logging.info(f"Ansible playbook generated: {output_file}")
    print(f"Ansible playbook generated: {output_file}")