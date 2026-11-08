variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 /16 CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && can(regex("/16$", var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid IPv4 /16 network."
  }
}

variable "availability_zones" {
  description = "Availability Zones for the VPC"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}

variable "enable_interface_endpoints" {
  description = "Create ECR API, ECR Docker, and CloudWatch Logs interface endpoints (additional hourly cost)"
  type        = bool
  default     = false
}
