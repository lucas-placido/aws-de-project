variable "rds-username" {
  type = string
  default = "postgres"
}

variable "rds-password" {
  type = string
  default = "postgres123"
  sensitive = true
}
