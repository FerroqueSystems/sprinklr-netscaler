# nsconf-to-IaC

* This repository contains Python scripts that convert NetScaler configuration (ns.conf) file to Infrastructure as Code (IaC) scripts such as Terraform or Ansible

## Prerequisites

- NetScaler ADC version 14.1 34.x and above

## How to use

To convert an nsconf file to Terraform script or Ansible playbook, use the `nsconf2iac.py` script. Below are the steps and command-line options:

### Command

```sh
python3 nsconf2iac.py [-h] -i INPUT -o OUTPUT [-v] -t TARGET_ADC -u USERNAME_ADC -p PASSWORD_ADC -type {terraform, ansible} [-a ADM_IP]
```
or 
```sh
python3 nsconf2iac.py -f FILE
```

Convert NS config to Terraform script or Ansible Playbook

```
Required arguments:
      -f FILE, --file FILE  
              Input inventory file containing configuration parameters.
              If specified, the following fields must be present in the file:
                target     - IP address of NetScaler
                username   - Username of NetScaler ADC/ADM(In case of ADM proxy)
                output     - Output file name
                type       - Type of output (terraform or ansible)
                adm_ip     - IP address of the ADM proxy server
                adm_id     - ID of the ADM proxy server
                adm_secret - Secret of the ADM proxy server
              The following are optional in the file:
                password   - Password of NetScaler ADC/ADM(In case of ADM proxy)
                input      - Path to ns.conf file
              Note: help and verbose can be provided via CLI if needed.


      If --file is not specified, the following CLI arguments are required:
              -t TARGET_ADC, --target-adc TARGET_ADC
                                    IP address of NetScaler
              -u USERNAME, --username USERNAME
                                    Username of NetScaler ADC/ADM(In case of ADM proxy)
              -o OUTPUT, --output OUTPUT
                                    Output file name
              -type {terraform, ansible}, --type {terraform, ansible}
                                    Type of output (terraform or ansible)
              -a ADM_IP, --adm-ip
                                    IP address of the ADM proxy server

Optional arguments:
              -p PASSWORD, --password PASSWORD
                                    Password of NetScaler ADC/ADM (In case of ADM proxy).
                                    If not specified, it will be taken from the environment
                                    variable NS_PASSWORD or prompted.

              -i INPUT, --input INPUT
                                    Input ns.conf file. Leave this empty to fetch ns.conf from
                                    the specified NetScaler.

              -v, --verbose         Enable verbose output

              -h, --help            Show this help message and exit

```

### Example

#### To generate Terraform Scripts
```sh
python3 nsconf2iac.py -i ns.conf -o main.tf -t 10.10.10.10 -u nsroot -p demopass -type terraform
```
#### To generate Ansible Playbook
```sh
python3 nsconf2iac.py -i ns.conf -o main.yaml -t 10.10.10.10 -u nsroot -p demopass -type ansible 
```
#### To generate with file input
```sh
python3 nsconf2iac.py -f inventory.ini
```
#### To generate with ADM proxy
```sh
python3 nsconf2iac.py -i ns.conf -o main.tf -t 10.10.10.10 -u nsroot -p demopass -a 1.1.1.1 -type terraform
```

##### Contents of inventory.ini file
```
target=<target-adc>
username=<username>
password=<password>
input=<ns.conf>
output=<output_file>
type=ansible/terraform
adm_ip=adm_ip #In case of ADM proxy
```

### Note

* If you are using Windows OS, replace `python3` with `python` in the command.
* The target ADC will parse the ns.conf using a NITRO API nsconfig (`/nitro/v1/config/nsconfig?action=convert`). This API will return the dependency graph. This API is available on NetScaler version 14.1 34.x and onwards. If you need to convert a configuration already deployed on a NetScaler, you can skip providing the input ns.conf. The tool will automatically retrieve the ns.conf from the target NetScaler for conversion. The tool then processes the graph output from the NetScaler and generates Terraform scripts.

## Limitations for Terraform

* Resources which are not yet supported in [CitrixADC Terraform Provider](https://registry.terraform.io/providers/citrix/citrixadc/latest/docs) will not be migrated, and the same is captured in log file - `unsupported_resources.log`.
* Currently, the generated terraform resource file might not have all dependencies generated accurately, this is applicable specifically for binding type of resources. Users are expected to review the generated file and make required dependency changes manually.
* Certain attributes under some resources are not yet supported by our provider. You can comment out those attributes in the generated terraform file.
* Custom bindings associated with default entities are not converted.

   Example: 
  * bind policy patset \<policyname> \<pattern>
  * bind ssl service \<servicename> -certkeyName \<certkeyname>


## Limitations for Ansible

* Resources which are not yet supported in [NetScaler ADC Ansible Collections](https://github.com/netscaler/ansible-collection-netscaleradc/blob/main/supported_modules_matrix.md) will not be migrated, and the same is captured in log file - `unsupported_resources.log`.
* Certain attributes under some resources are not yet supported by our collections. You can comment out those attributes in the generated Ansible playbook.

## Requirements

* python3.8 and above
* Install the required dependencies using:

    ```sh
    pip install -r requirements.txt
    ```
