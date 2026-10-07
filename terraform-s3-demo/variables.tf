variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name."
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Use 3-63 lowercase letters, digits and hyphens, starting and ending with a letter or digit."
  }
}
