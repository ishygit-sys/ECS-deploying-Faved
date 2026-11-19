variable "image_tag" {
  type = string

  validation {
    condition     = length(var.image_tag) > 0 # makes sure the image_variable is atleast 1 character
    error_message = "The image_tag variable must not be empty. Pass a valid commit SHA."
  }


}
