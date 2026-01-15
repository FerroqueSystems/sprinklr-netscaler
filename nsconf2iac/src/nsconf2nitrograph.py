import logging
import requests
import json
import time
import paramiko
import os
import urllib3 

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

protocol = "https"
def fetch(url, method="GET", data=None, headers=None, auth=None ):
    try:
        response = requests.request(method, url, data=data, headers=headers, auth=auth, verify = False)
        response.raise_for_status()
        if not response.text.strip():
            logging.warning(f"Empty response from {url}")
            return None
        return response.json()
    except requests.exceptions.RequestException as e:
        logging.error(f"Failed to fetch {url}")
        logging.error(f"Error: {e}")
        return None
    except ValueError as e:
        logging.error(f"Failed to parse JSON response: {e}")
        return None


def transfer_nsconf_to_target(target_adc, username_adc, password_adc, input_nsconf, adm_ip, verbose=False):
    # This function transfers the ns.conf file to the target ADC using SFTP
    # But when ADM IP is provided, it transfers the file to the ADM first
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        if adm_ip:
            ssh.connect(adm_ip, username=username_adc, password=password_adc)
        else:
            ssh.connect(target_adc, username=username_adc, password=password_adc)

        sftp = ssh.open_sftp()
        filename = os.path.basename(input_nsconf)
        if adm_ip:
            remote_path = f"/var/mps/tenants/root/config_mgmt/{filename}"
        else:
            remote_path = f"/var/tmp/{filename}"
        sftp.put(input_nsconf, remote_path)
        sftp.close()
        ssh.close()

        if verbose:
            logging.info(f"Transferred {input_nsconf} to {target_adc}:{remote_path}")
    except Exception as e:
        if adm_ip:
            logging.error(f"Failed to transfer {input_nsconf} to {target_adc}:/var/mps/tenants/root/config_mgmt/{os.path.basename(input_nsconf)}")
        else:
            logging.error(f"Failed to transfer {input_nsconf} to {target_adc}:/var/tmp/{os.path.basename(input_nsconf)}")
        logging.error(f"Error: {e}")
        raise

def transfer_nsconf_to_adc_via_adm(target_adc, sessid, input_nsconf, adm_ip, verbose=False):
    filename = os.path.basename(input_nsconf)
    headers = {"Content-Type": "application/json"}
    headers["Cookie"] = f"NITRO_AUTH_TOKEN={sessid}"
    id = None
    # Step 1: Create config job to transfer file from ADM to ADC
    try:
        url = f"{protocol}://{adm_ip}/nitro/v2/config/config_job"
        name = "transfer_nsconf_to_adc_temp"
        payload = {
            "config_job": {
                "name": name,
                "auto_rollback": "true",
                "execute_on_primary": "true",
                "execute_on_secondary": "false",
                "devices": [target_adc],  # Make sure this is a list of strings
                "on_error": "CONTINUE",
                "execute_sequentially": "false",
                "credentials_required": "false",
                "mail_profiles": "",
                "template_info": {
                    "commands": [
                        {"protocol": "SSH", "command": "shell", "rollback_command": ""},
                        {"protocol": "SCP", "command": f"put {filename} /var/tmp/{filename}", "rollback_command": ""},
                        {"protocol": "SSH", "command": "exit", "rollback_command": ""}
                    ],
                    "variables": [],
                    "device_family": "ns",
                    "is_inbuilt": "false",
                    "category": "",
                    "id": ""
                },
                "variables": [],
                "device_groups": [],
                "autoscale_groups": [],
            }
        }
        if verbose:
            logging.info(f"Creating config job with data: {payload}")
        response = requests.post(url, data=json.dumps(payload), headers=headers, verify=False)
        id = response.json()["config_job"][0]["id"]
        if response is None:
            logging.error("Failed to create config job on ADM")
    # Step 2: poll the job status until it is successful
        job_url = f"{protocol}://{adm_ip}/nitro/v1/config/config_job_details/{name}"
        if verbose:
            logging.info(f"Polling job status with URL: {job_url}")
        while True:
            job_response = fetch(job_url, headers=headers)
            if verbose:
                logging.info(f"Job response: {json.dumps(job_response)}")
            if job_response is None:
                logging.error("Job status request failed")
                break
            lastexecutionstatus = job_response["config_job_details"][0].get("lastExecutionStatus", "")
            status = job_response["config_job_details"][0].get("devices_info", [{}])[0].get("status", "")
            if status == "Completed" or lastexecutionstatus == "Completed":
                if verbose:
                    logging.info("Config job completed successfully")
                break   
            elif status == "Failed" or lastexecutionstatus == "Failed":
                logging.error("Config job status indicates failure")
                break
            else:
                if verbose:
                    logging.info(f"Config job status: {status}, last execution status: {lastexecutionstatus}")
            # Wait before polling again 
            time.sleep(10)
    except Exception as e:
        logging.error(f"Failed to create config job on ADM: {e}")

    # Step 3: Delete the config job
    try:
        if id is None:
            logging.error("No config job ID found, cannot delete job")
            raise Exception("No config job ID found")
        url = f"{protocol}://{adm_ip}/nitro/v2/config/config_job/{id}"
        if verbose:
            logging.info(f"Deleting config job with URL: {url}")
        response = fetch(url, method="DELETE", headers=headers)
        if response is None:
            logging.error("Failed to delete config job on ADM")
        if verbose:
            logging.info(f"Config job deleted successfully: {json.dumps(response)}")
    except Exception as e:
        logging.error(f"Failed to delete config job on ADM: {e}")
        return {}

def login(target, username, password, adm_ip=None, idsecret=False, verbose=False):
    global protocol
    if adm_ip:
        url = f"{protocol}://{adm_ip}/nitro/v2/config/login"
    else:
        url = f"{protocol}://{target}/nitro/v1/config/login"
    if verbose:
        logging.info(f"Attempting to login to {target} with user {username} with url: {url}")
    headers = {"Content-Type": "application/json"}
    if adm_ip and idsecret:
        data = json.dumps({"login": {"ID": username, "Secret": password}})
    else:
        data = json.dumps({"login": {"username": username, "password": password}})
    try:
        response = fetch(url, method="POST", data=data, headers=headers)
        if response is None:
            protocol = "http"
            url = url.replace("https://", "http://")
            if verbose:
                logging.info(f"Retrying login with HTTP: {url} with data: {data}")
            response = fetch(url, method="POST", data=data, headers=headers)
            if response is None:
                logging.error("Login failed")
                return None
        if verbose:
            logging.info(f"Login successful: {json.dumps(response)}")
        if adm_ip:
            return response["login"][0].get("sessionid", None)
        else:
            return response["sessionid"]
    except Exception as e:
        logging.error(f"Failed to login to {target}: {e}")
        return None

def logout(target, sessid, adm_ip=None, verbose=False):
    if adm_ip:
        url = f"{protocol}://{adm_ip}/nitro/v2/config/logout"
    else:
        url = f"{protocol}://{target}/nitro/v1/config/logout"
    headers = {"Content-Type": "application/json"}
    headers["Cookie"] = f"NITRO_AUTH_TOKEN={sessid}"
    
    payload = {"logout": {}}
    try:
        response = fetch(url, method="POST", headers=headers, data=json.dumps(payload))
        if response is None and adm_ip:
            logging.error("Logout failed")
            return False
        if verbose:
            logging.info(f"Logout successful")
        return True
    except Exception as e:
        logging.error(f"Failed to logout from {target}: {e}")
        return False

def convert_nsconf_to_nitrograph(target_adc, username, password, input_nsconf, adm_ip = None, idsecret=False, verbose=False):
    # Adjust logging level based on verbose flag
    if verbose:
        logging.getLogger().setLevel(logging.DEBUG)
        logging.getLogger("paramiko").setLevel(logging.DEBUG)
        logging.getLogger("requests").setLevel(logging.DEBUG)
        logging.info("Verbose logging enabled")
    else:
        logging.getLogger("paramiko").setLevel(logging.WARNING)
        logging.getLogger("requests").setLevel(logging.WARNING)
    if adm_ip:
        sessid = login(target_adc, username, password, adm_ip, idsecret, verbose=verbose)
    else:
        sessid = login(target_adc, username, password, verbose=verbose)
    # if the ns.conf is not specified by user, fetch it from the ADC
    if input_nsconf is None:
        data = json.dumps({"nsconfig": {"configfile": f"/nsconfig/ns.conf", "async": "true"}})
    else:
        transfer_nsconf_to_target(target_adc, username, password, input_nsconf, adm_ip, verbose)
        if adm_ip:
            transfer_nsconf_to_adc_via_adm(target_adc,sessid, input_nsconf, adm_ip, verbose)
            
        filename = os.path.basename(input_nsconf)
        data = json.dumps({"nsconfig": {"configfile": f"/var/tmp/{filename}", "async": "true"}})

    
    headers = {"Content-Type": "application/json"}
    headers["Cookie"] = f"NITRO_AUTH_TOKEN={sessid}"
    if adm_ip:
        url = f"{protocol}://{adm_ip}/nitro/v1/config/nsconfig?action=convert"
        headers["_MPS_API_PROXY_MANAGED_INSTANCE_IP"] = target_adc
    else:
        url= f"{protocol}://{target_adc}/nitro/v1/config/nsconfig?action=convert"
    
    if verbose:
        logging.info(f"Sending request to {url} with data: {data}")

    response = fetch(url, method="POST", data=data, headers=headers)
    if response is None:
        logging.error("Failed to convert ns.conf to nitrograph")
        return {}
    if verbose:
        logging.info(f"Response: {json.dumps(response)}")

    # Check if the necessary keys are in the response
    if "nsconfig" in response and "id" in response["nsconfig"]:
        job_id = response["nsconfig"]["id"]
    else:
        logging.error("Response does not contain 'nsconfig' or 'id' key")
        return {}
    
    # Poll the job status until it is successful
    if adm_ip:
        job_url = f"{protocol}://{adm_ip}/nitro/v1/config/nsjob/{job_id}"
    else:
        job_url = f"{protocol}://{target_adc}/nitro/v1/config/nsjob/{job_id}"
    while True:
        job_response = fetch(job_url, headers=headers)
        if job_response is None:
            logging.error("Job status request failed")
            return {}
        if "nsjob" in job_response and len(job_response["nsjob"]) > 0 :
            last_job_status = job_response["nsjob"][-1]
            if "status" in last_job_status and last_job_status["status"] == "Success":
                if "response" in last_job_status:
                    job_response_out = json.loads(last_job_status["response"])
                    break
                else:
                    logging.error("Job response does not contain 'response' key")
                    return {}
            elif "status" in last_job_status and last_job_status["status"] == "Failed":
                logging.error("Job status indicates failure")
                return {}
        else:
            logging.error("Job response does not contain 'nsjob' key or is empty")
            return {}
        time.sleep(10)

    if verbose:
        logging.info(f"Job response: {job_response_out}")
        
    logout(target_adc, sessid, adm_ip, verbose=verbose)

    if "converted_config" in job_response_out:
        return job_response_out["converted_config"]
    else:
        return job_response_out
