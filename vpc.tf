resource "aws_vpc" "ChallengeVPC" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "ChallengeTerraformVPC"
    }
}

resource "aws_subnet" "PublicSubnet1" {
    vpc_id = aws_vpc.ChallengeVPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet1"
    }
}

resource "aws_subnet" "PublicSubnet2" {
    vpc_id = aws_vpc.ChallengeVPC.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet2"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.ChallengeVPC.id
    tags = {
        Name = "IGW"
    }
}

resource "aws_route_table" "PublicRT" {
    vpc_id = aws_vpc.ChallengeVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
        Name = "PublicRT"
    }
}

resource "aws_route_table_association" "PublicRTAssociation1" {
  subnet_id  = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PublicRTAssociation2" {
  subnet_id  = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRT.id
}