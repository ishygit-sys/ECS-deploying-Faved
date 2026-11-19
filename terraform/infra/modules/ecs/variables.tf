
variable "subnet_ids" {
  type = list(string)

}


variable "alb_id" {
  type = string
}



variable "task-security_id" {
  type = string

}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "target_group_arn" {

}

variable "repository_url" {
  type = string
}


variable "image_tag" {
  type = string
}
