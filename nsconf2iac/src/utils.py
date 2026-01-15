import json
import re
import requests
from nitro_resource_map import NITRO_RESOURCE_MAP

state_map = {
    "present": "present",
    "absent": "absent",
    "bind": "present",
    "set": "present",
    "unbind": "absent",
    "update": "present",
    "force": "present",
    "apply": "applied",
    "enable": "enabled",
    "disable": "disabled",
    "rename": "renamed",
    "create": "created",
    "flush": "flushed",
    "import": "imported",
    "switch": "switched",
    "unset": "unset",
    "rm": "absent",
    "en": "enabled",
}

def construct_resource_block(resource_id, resource_properties={}):
    """
    Constructs a resource block
    """
    resource_block = {resource_id: resource_properties}
    return resource_block

def construct_ansible_task_block(resource_name, module_name, state):
    """
    Constructs an Ansible task block
    """
    if state.lower() not in state_map.keys():
        print(f"Unsupported state: {state}")
        return None
    task_block = {
        "name": f"Configure {resource_name}",
        "delegate_to": "localhost",
        f"{module_name}": {
            "nsip": "{{ nsip }}",
            "nitro_user": "{{ nitro_user }}",
            "nitro_pass": "{{ nitro_pass }}",
            "nitro_protocol": "{{ nitro_protocol }}",
            "validate_certs": "{{ validate_certs }}",
            "state": f"{state_map[state]}",
        }
    }
    return task_block

# Netscaler gives readonly attributes in nitrograp which are not allowed in ansible modules.
# This function removes those readonly attributes from the resource attributes.
def filter_readonly(attrs, resource_name):
	readwrite_attrs = NITRO_RESOURCE_MAP.get(resource_name, {}).get("readwrite_arguments", [])
	if isinstance(readwrite_attrs, dict):
		readwrite_attrs = readwrite_attrs.keys()
		new_attrs = attrs.copy()
		for attribute in attrs:
			if attribute not in readwrite_attrs:
                # popping attributes which are not in readwrite list (readonly)
				new_attrs.pop(attribute, None)
		attrs = new_attrs
	else:
		print("Error in retrieving readwrite attributes for " + resource_name)

	return attrs

def download_file(url, filename):
    response = requests.get(url)
    if response.status_code == 200:
        with open(filename, "wb") as file:
            file.write(response.content)
        return True
    return False


def sanitize(s):
    # Replace all some characters with underscores
    s = re.sub(r"[^\w-]", "_", s)

    # If the first character is a digit, prepend an underscore
    if s[0].isdigit():
        s = "_" + s

    return s


def tfjson2tf(tfjson, output_file="main.tf"):
    # Convert the Terraform .tf.json file to a .tf file
    # main.tf.json to main.tf
    with open(output_file, "w") as f:
        for resource_name, resource_data in tfjson["resource"].items():
            for resource_id, resource_properties in resource_data.items():
                if len(resource_properties) == 0:
                    with open("unsupported_resources.txt", "a") as ur:
                        ur.write(f"{resource_name}\n")
                    continue
                f.write(f'resource "{resource_name}" "{resource_id}" {{\n')
                for k, v in resource_properties.items():
                    if isinstance(v, str):
                        v = json.dumps(v)
                        v = v[1:-1]
                        f.write(f'  {k} = "{v}"\n')
                    elif isinstance(v, list):
                        if k == "depends_on":
                            value = "[" + ", ".join(v) + "]"
                        else:
                            value = "[\n" + ",\n".join([f'    "{item}"' for item in v]) + "\n  ]"
                        f.write(f"  {k} = {value}\n")
                    elif isinstance(v, bool):
                        f.write(f'  {k} = "{str(v).lower()}"\n')
                    else:
                        f.write(f'  {k} = "{v}"\n')
                f.write("}\n")
