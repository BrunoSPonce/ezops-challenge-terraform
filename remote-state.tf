terraform {
    backend "s3" {
        bucket = "ezops-test-bucket"
        key    = "terraform.tfstate"
        region     = "us-east-1"
        dynamodb_table = "dynamodb-bruno-test"
    }
}