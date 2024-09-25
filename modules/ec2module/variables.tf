variable "ami"{

default = "ami-0c2af51e265bd5e0e"

}

variable "type"{
default = "t3.medium"
}

variable "vpc"{

type = string
}

variable "demo_subnet1"{
type = string
}

variable "demo_subnet2"{
type = string
}

variable "demo_subnet_private"{
type = string
}



variable "vpc_security_group"{
type = list(string)
}
