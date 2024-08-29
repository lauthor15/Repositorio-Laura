resource "aws_vpc" "vpc_clase" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "vpc_Clase"
  }
}

resource "aws_subnet" "Subnet_clase_1" {
  vpc_id     = aws_vpc.vpc_clase.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Subnet_clase_1"
  }
}

resource "aws_internet_gateway" "gw_clase" {
  vpc_id     = aws_vpc.vpc_clase.id

  tags = {
    Name = "gw_clase"
  }
}

resource "aws_route_table" "rt_clase_1" {
    vpc_id     = aws_vpc.vpc_clase.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_clase.id
  }
  

  tags = {
    Name = "rt_defaul_clase"
  }
}

resource "aws_route_table_association" "a_rt_clase_1" {
  subnet_id      = aws_subnet.Subnet_clase_1.id
  route_table_id = aws_route_table.rt_clase_1.id
}

# agrego security_groups en la nueva rama
resource "aws_security_group" "sg_ssh" {
        name = "SG acceso SSH"
        description = "Permite el acceso SSH desde cualquier lugar"
        vpc_id = aws_vpc.vpc_clase.id

        tags = {
            Name = "SG_clase_acceso_SSH"
        }

        ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Permite acceso puerto 22"
        }

        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "permite salida a cualquier ip y puerto"
        }
    }
