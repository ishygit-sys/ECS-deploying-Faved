variable "vpc_id" {
  type = string
}


variable "subnet_ids" {
  type = list(string)

}


variable "alb-security_id" {
  type = string

}


variable "cert_arn" {
  type = string

}
