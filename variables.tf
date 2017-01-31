# MODULE VARIALBES
variable "env_name" {
  type        = "string"
  default     = ""
  description = "Environment name where module is deployed"
}

variable "tag_name" {
  type        = "string"
  default     = ""
  description = "tag name to filter instance to take action on"
}

variable "tag_value" {
  type        = "string"
  default     = ""
  description = "tag value to filter instance to take action on"
}

variable "time" {
  type    = "string"
  default = ""
}

variable "action" {
  type    = "string"
  default = "off"
}
