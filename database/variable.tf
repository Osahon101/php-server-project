variable "db_subnet_ids" {
  description = "List of subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "ID of the Database Security Group"
  type        = string
}

variable "db_username" {
    description = "database login username"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "database login password"
    type = string
    sensitive = true
}

