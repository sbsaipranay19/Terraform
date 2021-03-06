provider "aws" {
  region = "us-east-2"
}

#--------------------------------------------------------------------------------------------------------------------
# CREATE S3 Bucket
#--------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "terraform_state" {
  bucket = "s3example-testing"
  # Enable versioning so we can see the full revision history of our
  # state files
  force_destroy = true
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#--------------------------------------------------------------------------------------------------------------------
# CREATE Dynamo Table
#--------------------------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "dbtesting"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

#--------------------------------------------------------------------------------------------------------------------
# CREATE Remote Backend
#--------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "s3example-testing"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "dbtesting"
    encrypt        = true
  }
}