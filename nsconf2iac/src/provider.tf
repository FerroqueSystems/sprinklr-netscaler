
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
    