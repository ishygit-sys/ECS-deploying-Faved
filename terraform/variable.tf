variable "image_tag" {
  type = string

  validation {
    condition     = length(var.image_tag) > 0
    error_message = "The image_tag variable must not be empty. Pass a valid commit SHA."
  }


}
