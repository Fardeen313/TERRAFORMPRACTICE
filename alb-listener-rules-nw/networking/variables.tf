variable "region" {
  type    = string
  default = ""
}
variable "profile" {
  type    = string
  default = ""
}
variable "vpc_cidr" {
  type    = string
  default = ""
}
variable "cidr-pub-sub" {
  type    = string
  default = ""
}
variable "pub-sub-az" {
  type    = string
  default = ""
}
variable "cidr-pvt-sub" {
  type    = string
  default = ""
}
variable "pvt-sub-az" {
  type    = string
  default = ""
}
# TAGS 
variable "Vpc" {
  type    = string
  default = ""
}
variable "igw" {
  type    = string
  default = ""
}
variable "pub_sub" {
  type    = string
  default = ""
}
variable "pvt_sub" {
  type    = string
  default = ""
}
variable "pub_rt" {
  type    = string
  default = ""
}
variable "pvt_rt" {
  type    = string
  default = ""
}
variable "Ngw" {
  type    = string
  default = ""
}
variable "eip" {
  type    = string
  default = ""
}
variable "s_cidr" {
  type    = string
  default = ""
}
variable "domain" {
  type    = string
  default = ""
}
variable "name_sg" {
  type = string
  default = ""
}
variable "desc_sg" {
  type = string
  default = ""
}
variable "tag_sg" {
  type = string
  default = ""
}
variable "SSH" {
  type = number
  
}
variable "HTTP" {
  type = number
  
}
variable "MySQL" {
  type = number
 
}
variable "HTTPS" {
  type = number
  
}
variable "protocol" {
  type = string
  default = ""
}
variable "description_1" {
  type = string
  default = ""
}
variable "description_2" {
  type = string
  default = ""
}
variable "description_3" {
  type = string
  default = ""
}
variable "description_4" {
  type = string
  default = ""
}
variable "description_5" {
  type = string
  default = ""
}
variable "egress_from_port" {
  type = number
  
}
variable "egress_to_port" {
  type = number
  
}
variable "egress_protocol" {
  type = string
  
}
