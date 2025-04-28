variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}
variable "ingress_rules" {
  description = "A map of ingress rules"
  type = map(object({
    cidr_ipv4   = list(string)
    from_port   = number
    ip_protocol = string
    to_port     = number
    desciption  = string
  }))
}
variable "serucirty_group_id" {
  description = "The security group ID"
  type        = string
}
resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.ip_protocol
  cidr_blocks       = each.value.cidr_ipv4
  security_group_id = var.serucirty_group_id
  # security_group_id = aws_security_group.allow_tls.id

  description = each.value.desciption
}