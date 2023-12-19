# Instances

resource "aws_key_pair" "plu-asgroup" {
  key_name   = "plu-asgroup"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCshbE3gDvHblkKJhNPG2B5cQM2V71ePyRl1m+YCKdYkUZyLMWseEiyTq15L8m28PnWYDQBNNUFALMWcmxp1wmd7yZRbOCAeIvHtng4h5j7JlMembzLXtc/pnbPhBujwULIOQ3AhMgPPhTyE+m3OKhQj24Rg+5flkfwLrzNSxnNl1XWcktbtQvuyA0yDAXk4gZYEu1lFW8g8zLr1zAAFZbAoiXIPjjSh3St+8q9FQrc+9pCuJKqL56YpwHodN0leEz4BGopTtQrmjpDtRSWzQ1HHK6MDTGtFlp/rXRUX5C5PfzLxDQ603m7Q9DN/3EwTWxkisCQYmuzWn783OyxHpZgZNMfI83sOvIcnUebZpEZ3yN2ottlnsVYw4a6c6sM3UghtvSqyP5DR05w81m6OY+qn6EYkK8OaLQG+vqPCTeAu3CH06Jy9rGRW8pGJz1x1CIZ67AcOJQfKMxqIju0sX7D2EDdlbFykAkDb7rCo+kZNPY8VkNVwHRHQu68SkwM2wc= plu@optimus"
}

resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_az1_id
  vpc_security_group_ids = [var.ssh_security_group_id]
  key_name               = aws_key_pair.plu-asgroup.key_name

  tags = {
    Name = "Bastion Host"
  }
}
