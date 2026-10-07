mock_provider "aws" {}

run "private_bucket" {
  command = plan
  variables {
    bucket_name = "dibyo-24bcs10302-test"
  }
  assert {
    condition     = aws_s3_bucket.homework.force_destroy == false && aws_s3_bucket_public_access_block.homework.block_public_policy
    error_message = "The bucket must block public policies and preserve nonempty buckets on destroy."
  }
}

run "reject_invalid_bucket" {
  command = plan
  variables {
    bucket_name = "INVALID bucket"
  }
  expect_failures = [var.bucket_name]
}
