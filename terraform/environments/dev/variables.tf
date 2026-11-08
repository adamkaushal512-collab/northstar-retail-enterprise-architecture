variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "availability_zones" {
  type        = list(string)
  description = "Exactly two AZs in selected region"
}
variable "container_image" {
  type        = string
  description = "Existing private ECR image URI for Reservation Service"
}
variable "alb_certificate_arn" {
  type        = string
  description = "Existing validated ACM certificate ARN"
}
variable "enable_interface_endpoints" {
  type    = bool
  default = false
}
