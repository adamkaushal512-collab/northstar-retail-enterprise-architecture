locals {
  interface_services = toset(["ecr.api", "ecr.dkr", "logs"])
}
resource "aws_security_group" "interface_endpoints" {
  count       = var.enable_interface_endpoints ? 1 : 0
  name_prefix = "northstar-${var.environment}-endpoints-"
  description = "Private AWS interface endpoint HTTPS access from private subnet CIDRs"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "northstar-${var.environment}-endpoints", Environment = var.environment }
}
resource "aws_vpc_security_group_ingress_rule" "endpoint_https" {
  count             = var.enable_interface_endpoints ? 1 : 0
  security_group_id = aws_security_group.interface_endpoints[0].id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "HTTPS from VPC workloads"
}
resource "aws_vpc_security_group_egress_rule" "endpoint_response" {
  count             = var.enable_interface_endpoints ? 1 : 0
  security_group_id = aws_security_group.interface_endpoints[0].id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1"
  description       = "VPC-local endpoint traffic"
}
resource "aws_vpc_endpoint" "interfaces" {
  for_each            = var.enable_interface_endpoints ? local.interface_services : toset([])
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.interface_endpoints[0].id]
  tags                = { Name = "northstar-${var.environment}-${replace(each.value, ".", "-")}-endpoint", Environment = var.environment }
}
