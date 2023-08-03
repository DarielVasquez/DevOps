resource "tls_private_key" "PK" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "Keypair" {
  key_name   = "keypair"
  public_key = tls_private_key.PK.public_key_openssh
}

resource "local_file" "local_key_pair" {
  filename = "keypair.pem"
  file_permission = "0400"
  content = tls_private_key.PK.private_key_pem
}