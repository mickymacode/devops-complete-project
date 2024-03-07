variable region {
  default = "ap-southeast-2"
}

variable vpc_cidr_block {
  default = "10.1.0.0/16"
}

variable subent_cidr_block_1 {
  default = "10.1.1.0/24"
}

variable subent_cidr_block_2 {
  default = "10.1.2.0/24"
}

variable availability_zone_1 {
    default = "ap-southeast-2a"
}
variable availability_zone_2 {
    default = "ap-southeast-2b"
}
variable instance_type {
    default = "t2.micro"
}

variable tag_names {
    default = ["jenkins-master", "jenkins-slave", "ansible"]
}
