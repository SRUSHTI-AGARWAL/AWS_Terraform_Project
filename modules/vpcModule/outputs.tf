output "vpc"{

value = aws_vpc.demo_vpc.id

}

output "demo_subnet1"{

value = aws_subnet.demo_subnet1.id
}


output "demo_subnet2"{

value = aws_subnet.demo_subnet2.id
}

output "demo_subnet_private"{

value = aws_subnet.demo_subnet_private.id
}

output "vpc_security_group" {

value = aws_security_group.demo_sg.id

}



