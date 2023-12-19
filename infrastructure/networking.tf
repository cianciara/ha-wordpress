# NETWORKING ####################################################################

# VPC ---------------------------------------------------------------------------

resource "aws_vpc" "wordpress" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Wordpress-VPC"
  }
}

resource "aws_internet_gateway" "wordpress" {
  vpc_id = aws_vpc.wordpress.id

  tags = {
    Name = "Wordpress-IG"
  }
}

# SUBNETS ------------------------------------------------------------------------

resource "aws_subnet" "public_subnet_az1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.wordpress.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Public Subnet AZ1"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.wordpress.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Public Subnet AZ2"
  }
}

resource "aws_subnet" "private_app_subnet_az1" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.wordpress.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private App Subnet AZ1"
  }
}

resource "aws_subnet" "private_app_subnet_az2" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.wordpress.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Private App Subnet AZ2"
  }
}

resource "aws_subnet" "private_data_subnet_az1" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.wordpress.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private Data Subnet AZ1"
  }
}

resource "aws_subnet" "private_data_subnet_az2" {
  cidr_block        = "10.0.5.0/24"
  vpc_id            = aws_vpc.wordpress.id
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Private Data Subnet AZ1"
  }
}

# NAT GATEWAYS --------------------------------------------------------------------

resource "aws_eip" "nat_az1_eip" {
  depends_on = [aws_internet_gateway.wordpress]
}

resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat_az1_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "nat_az1"
  }

  depends_on = [aws_internet_gateway.wordpress, aws_eip.nat_az1_eip]
}

resource "aws_eip" "nat_az2_eip" {
  depends_on = [aws_internet_gateway.wordpress]
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_az2_eip.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = {
    Name = "nat_az2"
  }

  depends_on = [aws_internet_gateway.wordpress, aws_eip.nat_az2_eip]
}

# ROUTING -------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.wordpress.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_rtb_az1" {
  vpc_id = aws_vpc.wordpress.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az1.id
  }

  tags = {
    Name = "Private Route Table AZ1"
  }
}

resource "aws_route_table_association" "private_app_subnet_az1" {
  subnet_id      = aws_subnet.private_app_subnet_az1.id
  route_table_id = aws_route_table.private_rtb_az1.id
}

resource "aws_route_table_association" "private_data_subnet_az1" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.private_rtb_az1.id
}

resource "aws_route_table" "private_rtb_az2" {
  vpc_id = aws_vpc.wordpress.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az2.id
  }

  tags = {
    Name = "Private Route Table AZ2"
  }
}

resource "aws_route_table_association" "private_app_subnet_az2" {
  subnet_id      = aws_subnet.private_app_subnet_az2.id
  route_table_id = aws_route_table.private_rtb_az2.id
}

resource "aws_route_table_association" "private_data_subnet_az2" {
  subnet_id      = aws_subnet.private_data_subnet_az2.id
  route_table_id = aws_route_table.private_rtb_az2.id
}

# SECURITY GROUPS # ------------------------------------------------------------------  

# ALB security group
resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = aws_vpc.wordpress.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }
}

# SSH Security group
resource "aws_security_group" "ssh_sg" {
  name   = "ssh_sg"
  vpc_id = aws_vpc.wordpress.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["83.16.10.246/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

# webserver security group
resource "aws_security_group" "webserver_sg" {
  name   = "webserver_sg"
  vpc_id = aws_vpc.wordpress.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Webserver Security Group"
  }
}

# database security group
resource "aws_security_group" "database_sg" {
  name   = "database_sg"
  vpc_id = aws_vpc.wordpress.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

# EFS security group
resource "aws_security_group" "efs_sg" {
  name   = "efs_sg"
  vpc_id = aws_vpc.wordpress.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EFS Security Group"
  }
}