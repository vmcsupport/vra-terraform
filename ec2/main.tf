module "datalookup" {
  source = "../data"
  custexample = var.custexample
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
 count         = 1# var.ec2_count
 ami           = data.aws_ami.latest.id
 instance_type = var.instance_type
 subnet_id = tolist(module.datalookup.public_subnets_ids)[count.index] #element(module.datalookup.public_subnets_ids,count.index)
  
 tags = {
    Name        = var.instance_name
  }

  lifecycle {
    ignore_changes = [private_ip, root_block_device, user_data, ami]
  }
}

