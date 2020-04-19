# Instance
resource "aws_instance" "ec2" {
  ami                   = var.ami
  instance_type         = var.instance_size
  availability_zone     = var.az_map[var.subnet_id]
  key_name              = var.key_name
  network_interface {
      network_interface_id = aws_network_interface.eni.id
      device_index         = 0
  }
}

# Elastic IP
resource "aws_network_interface" "eni" {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.wordpress_personal.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.eni.id
}