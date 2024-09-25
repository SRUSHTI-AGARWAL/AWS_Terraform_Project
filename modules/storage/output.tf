output "s3bucketarn"{
value = aws_s3_bucket.demo_bucket.arn
}

output "bucket_name"{

value = aws_s3_bucket.demo_bucket.id

}
