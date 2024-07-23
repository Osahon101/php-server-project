variable "vpc-cidr" {
  description = "vpc cidr block"
  type        = string
  default = "10.0.0.0/16"

}

variable "vpc-tag" {
  description = "default tag for vpc"
  type        = string

}
variable "availability_zone" {
  description = "availability zones for NAT and ALB"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]

}

variable "Subnet_1_2_cidr" {
  description = "cidr blocks for subnet 1 & 2"
  type        = list(string)
  default     = ["10.0.5.0/28", "10.0.10.0/28"]

}

variable "subnet_1_2_tags" {
  description = "tags for subnet 1 & 2"
  type        = list(string)
  default     = ["NAT-ALB-Subnet-1", "NAT-ABL-Subnet-2"]

}

variable "Webserver-subnet-cidr" {
  description = "cidr for webservers subnets"
  type        = list(string)
  default     = ["10.0.14.0/23", "10.0.20.0/23"]

}

variable "webservers-tags" {
  description = "default tags for webservers subnet"
  type        = list(string)
  default     = ["Webserver-subnet-1", "Webserver-subnet-2"]

}

variable "appserver-cidr" {
  description = "cidr for the app hosting servers"
  type        = list(string)
  default     = ["10.0.2.0/23", "10.0.30.0/23"]
}

variable "appserver-tags" {
  description = "default tags for the appservers subnet"
  type        = list(string)
  default     = ["appserver-subnet-1", "appserver-subnet-2"]
}

variable "database-subnet-cidr" {
  description = "cidr for the database subnets"
  type        = list(string)
  default     = ["10.0.35.0/28", "10.0.40.0/28"]

}

variable "database-subnet-tags" {
  description = "default tags for database subnets"
  type        = list(string)
  default     = ["db-subnet-1", "db-subnet-2"]
}

variable "route_table_tags" {
  description = "List of route table default tags"
  type        = list(string)
  default = [
    "NAT-ALB-Public-RT-1",
    "NAT-ALB-Public-RT-2",
    "Webserver-RT-1",
    "Webserver-RT-2",
    "Appserver-RT-1",
    "Appserver-RT-2",
    "Database-RT-1",
    "Database-RT-2",
  ]
}

variable "subnet-list" {
  description = "list of subnets using their logical names"
  type        = list(string)
  default     = ["value"]

}

# Define a map variable for subnet associations
variable "subnet_rt_associations" {
  type = map(number)
  default = {
    "aws_subnet.NAT-ALB-PublicSubnets.0" = 0,
    "aws_subnet.NAT-ALB-PublicSubnets.1" = 1,  
    "aws_subnet.Webserver-subnets.0" = 2,
    "aws_subnet.Webserver-subnets.1" = 3,  
    "aws_subnet.Appserver-subnets.0" = 4,
    "aws_subnet.Appserver-subnets.1" = 5,  
    "aws_subnet.database-subnets.0" = 6,
    "aws_subnet.database-subnets.1" = 7,  
  }
}


