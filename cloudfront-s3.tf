resource "aws_s3_bucket" "s3_bucket-test" {
    bucket = "cloudfront-ezops-test-bruno-bucket"
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configuration-bruno-test" {
  bucket = aws_s3_bucket.s3_bucket-test.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_policy" "s3_bucket_policy-bruno-test" {
  bucket = aws_s3_bucket.s3_bucket-test.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowPublic"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Resource  = ["${aws_s3_bucket.s3_bucket-test.arn}", "${aws_s3_bucket.s3_bucket-test.arn}/*"]
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "aws_cloudfront_distribution-test-bruno" {
  comment = "CloudFront distribution for Vue.js EZOps Test Bruno"
  enabled = true
  
  origin {
    origin_id                = aws_s3_bucket.s3_bucket-test.bucket
    domain_name              = "${aws_s3_bucket.s3_bucket-test.bucket}.s3-website-us-east-1.amazonaws.com"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {
    
    target_origin_id = aws_s3_bucket.s3_bucket-test.bucket
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_200"
  
}