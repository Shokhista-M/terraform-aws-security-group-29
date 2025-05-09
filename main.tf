variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}
variable "security_group_name" {
  description = "The name of the security group"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the security group"
  type        = string
}
resource "aws_security_group" "allow_tls" {
  name        = var.security_group_name
  vpc_id      = var.vpc_id

  tags = {
    Name = var.tags
  }
}
variable "security_group_id" {
  description = "The security group ID"
  type        = string
}
variable "ingress_rules" {
  description = "A map of ingress rules"
  type = map(object({
    cidr_ipv4   = list(string)
    from_port   = number
    ip_protocol = string
    to_port     = number
    description = string
  }))
}
resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.ip_protocol
  cidr_blocks       = each.value.cidr_ipv4
  security_group_id = var.security_group_id

  description = each.value.description
}
variable "egress_rules" {
  description = "A map of egress rules"
  type = map(object({
    cidr_ipv4   = list(string)
    from_port   = number
    ip_protocol = string
    to_port     = number
    description = string
  }))
}
resource "aws_security_group_rule" "egress" {
  for_each = var.egress_rules

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.ip_protocol
  cidr_blocks       = each.value.cidr_ipv4
  security_group_id = var.security_group_id

  description = each.value.description
}
