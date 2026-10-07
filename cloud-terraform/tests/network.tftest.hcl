mock_provider "aws" {}

run "public_network" {
  command = plan
  assert {
    condition     = aws_vpc.homework.cidr_block == "10.0.0.0/16" && aws_subnet.public.cidr_block == "10.0.1.0/24" && aws_subnet.public.map_public_ip_on_launch
    error_message = "The public subnet must have the assigned address range and public IP mapping."
  }
  assert {
    condition     = length(aws_security_group.web.ingress) == 2 && alltrue([for rule in aws_security_group.web.ingress : contains([80, 443], rule.from_port) && rule.from_port == rule.to_port && rule.protocol == "tcp"])
    error_message = "Only HTTP and HTTPS ingress are permitted."
  }
  assert {
    condition     = one(aws_route_table.public.route).cidr_block == "0.0.0.0/0"
    error_message = "The public route table needs an internet default route."
  }
  assert {
    condition     = aws_instance.web.metadata_options[0].http_tokens == "required" && aws_instance.web.root_block_device[0].encrypted && aws_s3_bucket_public_access_block.artifacts.block_public_policy
    error_message = "The host must use IMDSv2 and encrypted storage, and artifacts must block public policies."
  }
}

run "reject_shell_in_image" {
  command = plan
  variables {
    container_image = "nginx; touch /tmp/injected"
  }
  expect_failures = [var.container_image]
}

run "reject_invalid_port" {
  command = plan
  variables {
    container_port = 65536
  }
  expect_failures = [var.container_port]
}
