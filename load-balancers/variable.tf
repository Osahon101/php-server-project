variable "vpc_id" {
  description = "VPC ID"
}

variable "frontend_lb_subnet_ids" {
  description = "List of subnet IDs for the frontend load balancer"
  type        = list(string)
}

variable "frontend_lb_sg_name" {
  description = "Name for the Frontend Load Balancer Security Group"
  type        = string
  default = "front-lb-sg"
}

variable "backend_lb_subnet_ids" {
  description = "List of subnet IDs for the backend load balancer"
  type        = list(string)
}

variable "backend_lb_sg_name" {
  description = "Name for the Backend Load Balancer Security Group"
  type        = string
}

variable "Webserver_sg_id" {
  description = "ID of the Webserver Security Group"
  type        = string
}
