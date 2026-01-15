import argparse
import logging
import os
import sys
import getpass
from nsconf2nitrograph import convert_nsconf_to_nitrograph
from nitrograph2tf import convert_nitrograph_to_tf
from nitrograph2ansible import convert_nitrograph_to_ansible

logging.root.handlers = []

# Configure logging to write to a file
log_file = "nsconf2iac1.log"
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler(log_file, mode="w", delay=True),
    ],
)


def main():
    parser = argparse.ArgumentParser(description="Convert NetScaler config to Terraform script or Ansible playbook")

    parser.add_argument("-f", "--file", type=str, help="Credential file with target-adc, username-adc, password-adc, input, output, type", required=False)
    parser.add_argument("-i", "--input", type=str, help="Input nsconf file. Leave this empty to fetch the ns.conf from the specified NetScaler.", required=False)
    parser.add_argument("-o", "--output", type=str, help="Output file name", required=False)
    parser.add_argument("-t", "--target-adc", help="IP address of NetScaler", required=False)
    parser.add_argument("-u", "--username", type=str, help="Username of NetScaler ADC/ADM(In case of ADM proxy)", required=False)
    parser.add_argument("-p", "--password", type=str, help="Password of NetScaler ADC/ADM(In case of ADM proxy). If not provided, it will be taken from `NS_PASSWORD` env or prompted.", required=False)
    parser.add_argument("-type", "--type", type=str, help="Type of output (terraform/ansible)", required=False, choices=["terraform", "ansible"])
    parser.add_argument("-v", "--verbose", help="Enable verbose output", action="store_true")
    parser.add_argument("-a", "--adm-ip", type=str, help="IP address of the ADM proxy server", required=False)
    parser.add_argument("-id", "--adm-id", type=str, help="ID of the ADM proxy server", required=False)
    parser.add_argument("-s", "--adm-secret", type=str, help="Secret of the ADM proxy server", required=False)
    args = parser.parse_args()
    # if no args, print help
    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(1)

    # If only one argument is provided, it must be a file
    if len(sys.argv) == 2:
        if not args.file:
            print("Error: Provide a file")
            sys.exit(1)
        elif os.path.exists(sys.argv[1]):
            args.file = sys.argv[1]
        else:
            print(f"Error: Argument '{sys.argv[1]}' is not a valid file.")
            sys.exit(1)

    # If a file is provided, read the arguments from the file
    if args.file:
        if not os.path.isfile(args.file):
            print(f"Error: Credential file '{args.file}' does not exist.")
            sys.exit(1)
        with open(args.file, 'r') as f:
            lines = f.readlines()
            for line in lines:
                key, value = line.strip().split('=')
                if key == "target-adc":
                    args.target_adc = value
                elif key == "username":
                    args.username = value
                elif key == "password":
                    args.password_adc = value
                elif key == "input":
                    args.input = value
                elif key == "output":
                    args.output = value
                elif key == "type":
                    args.type = value
                elif key == "verbose":
                    args.verbose = value.lower() == 'true'
                elif key == "adm_ip":
                    args.adm_ip = value
                elif key == "adm_id":
                    args.adm_id = value
                elif key == "adm_secret":
                    args.adm_secret = value

    if args.username and args.adm_secret:
        print("Error: Both username and adm_secret are provided. Please provide either username or adm_secret, not both.")
        sys.exit(1)
    # Ensure all required arguments are provided
    missing_args = []
    if not args.target_adc:
        missing_args.append("target-adc")
    if not args.type:
        missing_args.append("type")
    if not args.username:
        if not args.adm_ip:
            missing_args.append("username")
        elif not args.adm_id:
            missing_args.append("username/adm_id")
    if not args.output:
        missing_args.append("output")
    if missing_args:
        print(f"Error: Missing required arguments: {', '.join(missing_args)}")
        sys.exit(1)

    # Handle password: Prefer environment variable, then CLI, then secure prompt
    if not args.adm_id:
        if not args.password:
            args.password = os.getenv("NS_PASSWORD")  # Get from env variable
        if not args.password:  # If still empty, prompt securely
            args.password = getpass.getpass("Enter NetScaler ADC/Console password: ")
        if args.password is None:
            logging.error("Password is required. Use -p or set environment variable `NS_PASSWORD`")
            sys.exit(1)
    else:
        if not args.adm_secret:
            args.adm_secret = os.getenv("NS_SECRET") # Get from env variable
        if not args.adm_secret:  # If still empty, prompt securely
            args.adm_secret = getpass.getpass("Enter ADM proxy secret: ")
        if args.adm_secret is None:
            logging.error("ADM proxy secret is required. Use -s or set environment variable `NS_SECRET`")
            sys.exit(1)

    # Ensure input file exists (if provided)
    if args.input and not os.path.isfile(args.input):
        print(f"Error: Input file '{args.input}' does not exist.")
        exit(1)

    # Adjust logging level based on verbose flag
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
        logging.getLogger("requests").setLevel(logging.DEBUG)
        logging.getLogger("urllib3").setLevel(logging.DEBUG)
        logging.info("Verbose logging enabled")
    else:
        logging.getLogger("requests").setLevel(logging.WARNING)
        logging.getLogger("urllib3").setLevel(logging.WARNING)

    # if no args, print help
    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(1)
    if args.adm_id and args.adm_secret:
        args.username = args.adm_id
        args.password = args.adm_secret
    print("Converting NS config to " + args.type + " script...")
    if args.verbose:
        logging.info("Converting NS config to Nitrograph...")
    # Step 1: Convert NS config to Nitrograph
    idsecret = False
    if args.adm_id and args.adm_secret:
        idsecret = True
    nitrograph_data = convert_nsconf_to_nitrograph(args.target_adc, args.username, args.password, args.input, args.adm_ip, idsecret, args.verbose)
    if not nitrograph_data:
        logging.error("Got empty Nitrograph data")
        logging.error("Failed to convert NS config to Nitrograph")
        sys.exit(1)
    # Step 2: Convert Nitrograph to Terraform/Ansible based on user input
    if args.type == "terraform":
        if args.verbose:
            logging.info("Converting the Nitrograph to the Terraform script...")
        convert_nitrograph_to_tf(nitrograph_data, args.output, args.verbose)
    else:
        if args.verbose:
            logging.info("Converting the Nitrograph to the Ansible script...")
        convert_nitrograph_to_ansible(nitrograph_data, args.output, args.verbose)

if __name__ == "__main__":
    main()
