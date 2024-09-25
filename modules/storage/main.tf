resource "aws_s3_bucket" "demo_bucket" {
bucket = "uniquedemos3"
}

resource "aws_s3_bucket_versioning" "versioning_demo" {
  bucket = aws_s3_bucket.demo_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "null_resource" "empty_bucket" {
  provisioner "local-exec" {
    command = "aws s3 rm s3://uniquedemos3 --recursive"
  }

  depends_on = [aws_s3_bucket.demo_bucket]
}


