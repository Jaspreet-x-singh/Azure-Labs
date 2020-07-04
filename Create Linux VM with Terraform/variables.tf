variable "location" {}

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
}

variable "prefix" {
    type = string
    default = "mata"
}

variable "tags" {
    type = map(string)

    default = {
        Environment = "Terraform GS"
        Dept = "Engineering"
  }
}

variable "sku" {
    default = {
        "Australia East" = "16.04-LTS" 
        "Australia East" = "18.04-LTS"
    }
}
