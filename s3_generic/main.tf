resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
  #  region        = var.region

  versioning {
    enabled = true
  }

  tags = {
    Name        = var.bucket_name
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


data "template_file" "s3-bucket-rw-policy" {
  template = file("./generic-bucket-rw-policy.json")

  vars = {
    bucket = aws_s3_bucket.this.id
  }
}

