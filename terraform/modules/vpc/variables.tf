variable "cidr_vpc" {
  description = "vpc cidr value"
 type = string
}

variable "cidr_publicsubnet" {
    description = "public subnet value"
  type = list(string)
}

variable "cidr_privatesubnet" {
    description = "private subnet value"
  type = list(string)
}


variable "availability_zone" {
    description = "availability zones"
  type = list(string)
}

variable "cluster_name" {
  description = "name of eks cluster"
  type = string
}