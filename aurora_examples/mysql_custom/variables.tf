variable "availability_zones" {
  description = "The availability zones used by cluster."
  type        = list(string)
}

variable "cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
}

variable "environment" {
  description = "Name of environment being deployed. (e.g. lowers, production)"
  type = string
}

variable "master_username" {
  description = "Master DB username"
  type        = string
}

variable "master_password" {
  description = "Master DB password."
  type        = string
}

variable "subnet_group_ids" {
  description = "A list of VPC subnet IDs."
  type = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {
    Name      = "Aurora-Test"
    CreatedBy = "Terraform"
  }
}

variable "vpc_id" {
  description = "The VPC ID."
  type = string
}