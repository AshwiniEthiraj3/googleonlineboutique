variable "cluster_name" {
  description = " value for eks cluster"
  type = string
}

variable "cluster_version" {
  description = " for cluster version"
  type = string
}

variable "subnet_ids" {
  description = "value for subnet ids"
  type = list(string)
}
variable "vpc_id" {
  description = "value for vpc id"
  type = string
}
variable "node_groups" {
  description = "value for node groups"
  type = map(object({
    instance_types=list(string)
    capacity_type=string
    scaling_config=object({
      desired_size = number
      max_size=number
      min_size=number 
    }) 
  }))
}