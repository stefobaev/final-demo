resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "acls3" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versionings3" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_dynamodb_table" "dynamoDbTreti" {
#   name             = "dynamoDbTreti"
#   hash_key         = "id"
#   #billing_mode   = "PROVISIONED"
#   read_capacity  = 5
#   write_capacity = 5
#   attribute {
#     name = "id"
#     type = "S"
#   }
#   tags = {
#     "Name" = "dynamoDb"
#   }
# }