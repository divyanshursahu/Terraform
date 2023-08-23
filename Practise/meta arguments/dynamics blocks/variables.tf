variable "rgname" {
  default = "dynamic-rg"
}

variable "vnet_name" {
  default = "dynamic-vnet"
}

variable "location" {
  default = "central India"
}

variable "subnets" {
  default = [ {
    name = "subnettest"
    address_space = "10.1.0.0/24"
  } ]
  type = list(object({
    name = string
    address_space = string
  }))
}