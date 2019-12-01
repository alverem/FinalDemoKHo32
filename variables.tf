variable "creds" {
  default = "<your-json>"
  type        = string
  description = "Credentionals"
}

variable "region" {
  default     = "europe-west4"
  type        = string
  description = "our region"
}

variable "zone" {
  default     = "europe-west4-a"
  type        = string
  description = "our zone"
}

variable "image" {
  default     = "centos-cloud/centos-8-v20191115"
  type        = string
  description = "We use CentOS 8 image"
}

variable "project" {
  default     = "finaldemokh032"
  type        = string
  description = "our project's id"
}

variable "inst-name" {
  default     = "jenkins"
  type        = string
  description = "Instance's name"
}

variable "type" {
  default     = "n1-standard-1"
  type        = string
  description = "machine type"
}
