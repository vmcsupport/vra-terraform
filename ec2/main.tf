module "datalookup" {
  source = "../data"
  publicsubnetnames = ["ice-ad-${var.custexample}-prod-pubc"]
#var.publicsubnetnames 
}

data "aws_ami" "latest" {
  most_recent = true
  owners           = ["self"]
  filter {
    name   = "name"
    values = ["${var.image}-goldenimage-*"]
  }
}

resource "aws_instance" "this" {
 ami           = data.aws_ami.latest.id
 instance_type = var.instance_type
 subnet_id = "subnet-04e15ab67ff977298"

  tags = {
    Name        = var.instance_name
  }

  lifecycle {
    ignore_changes = [private_ip, root_block_device, user_data, ami]
  }
}

