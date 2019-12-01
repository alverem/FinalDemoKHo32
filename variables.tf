variable "creds" {
  default = "finaldemokh032-e628298ba948.json"
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

variable "project" {
  default     = "finaldemokh032"
  type        = string
  description = "our project's id"
}

variable "cluster-name" {
  default     = "cluster"
  type        = string
  description = "Cluster's name"
}
