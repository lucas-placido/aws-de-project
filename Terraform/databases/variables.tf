variable "rds-username" {
  type = string
  default = "postgres"
}

variable "rds-password" {
  type = string
  default = "postgres123"
  sensitive = true
}


variable "rds_db_name" {
  default = "mydb"
}

variable "security_group_allow_tls_id" {
  
}
