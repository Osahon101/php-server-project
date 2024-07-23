output "NAT-ALB-PublicSubnets" {
  value = aws_subnet.NAT-ALB-PublicSubnets[*].id
}

output "Webserver-subnets" {
  value = aws_subnet.Webserver-subnets[*].id
}

output "Appserver-subnets" {
  value = aws_subnet.Appserver-subnets[*].id
}

output "database-subnets" {
  value = aws_subnet.database-subnets[*].id
}

output "project-route-table" {
  value = aws_route_table.project-RT[*].id
}

output "vpc_id" {
  value = aws_vpc.Prod-VPC.id
}
