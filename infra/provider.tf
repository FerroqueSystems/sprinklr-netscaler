
terraform {
    required_providers {
        citrixadc = {
        source = "citrix/citrixadc"
        }
    }
}

provider "citrixadc" {
    endpoint = "http://${var.public_nsip}"
    username = "nsroot"
    password = var.adc_admin_password
}
    