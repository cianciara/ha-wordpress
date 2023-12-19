# launch template
resource "aws_launch_template" "wordpress_lt" {
  name_prefix            = "WordpressLT"
  description            = "Wordpress Launch Template"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.plu-asgroup.key_name
  vpc_security_group_ids = [var.webserver_security_group_id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd 
sudo systemctl start httpd
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install mysql-community-server -y
sudo systemctl enable mysqld
sudo systemctl start mysqld
echo "${var.efs_wordpress_dns_name}:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a
chown apache:apache -R /var/www/html
sudo service httpd restart
EOF
  )

  tags = {
    Name = "Webserver Template"
  }
}

#SNS topic
resource "aws_sns_topic" "wordpress-asg" {
  name = "wordpress-asg"
}

# autoscaling group
resource "aws_autoscaling_group" "wordpress-asg" {
  vpc_zone_identifier       = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  target_group_arns         = [aws_lb_target_group.wordpress-alb-tg.arn]
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = "300"
  depends_on                = [aws_lb_target_group.wordpress-alb-tg]

  launch_template {
    id = aws_launch_template.wordpress_lt.id
  }
}

resource "aws_autoscaling_notification" "wordpress-asg-notification" {
  group_names = [
    aws_autoscaling_group.wordpress-asg.name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.wordpress-asg.arn
}