###############################
## Define ECS cluster
###############################
resource "aws_ecs_cluster" "example_cluster" {
  name = "${var.ecs_name}"
}

########################
## Deploy the keypair ##
########################
resource "aws_key_pair" "ecs_keypair" {
  key_name   = "${var.ecs_keypair}"
  public_key = "${var.ecs_keypair_public_key}"
}

########################################
## Create an SG for the EC2 instances ##
########################################
resource "aws_security_group" "allow_internal_traffic" {
  name        = "ecs_sg_allow_internal_traffic"
  description = "Allow all internal traffic"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "allow_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.allow_internal_traffic.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type            = "egress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.allow_internal_traffic.id}"
}

##############################
## Define ASG for instances ##
##############################
resource "aws_autoscaling_group" "ecs_cluster_instances" {
  name                  = "ecs-cluster-instances"
  #availability_zones   = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_zone_identifier   = [ "${var.subnets}" ]
  min_size              = "${var.ecs_asg_min_size}"
  max_size              = "${var.ecs_asg_max_size}"
  desired_capacity      = "${var.ecs_asg_min_size}"
  launch_configuration  = "${aws_launch_configuration.ecs_lc_instances.name}"
#  tags                 = { Name = "ECS-Instance" }
}

#########################################
## Define Launch Configuration for ASG ##
#########################################
resource "aws_launch_configuration" "ecs_lc_instances" {
  name                    = "ecs-instance-3"
  instance_type           = "${var.ecs_asg_lc_instance_type}"
  image_id                = "${var.ecs_asg_lc_image_id}"
  security_groups         = [ "${aws_security_group.allow_internal_traffic.id}" ]
  associate_public_ip_address = true
  iam_instance_profile    = "${var.ecs_asg_iam_instance_profile}"
  key_name                = "${aws_key_pair.ecs_keypair.key_name}"
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.example_cluster.name} >> /etc/ecs/ecs.config
yum update
yum install vim
EOF
}

###################################################
## Define increase and decrease policies for ASG ##
###################################################
resource "aws_autoscaling_policy" "ecs_policy_increase_instances" {
  name                   = "ECS ASG Increase Instances"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster_instances.name}"
}

resource "aws_autoscaling_policy" "ecs_policy_decrease_instances" {
  name                   = "ECS ASG Decrease Instances"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster_instances.name}"
}

############################################
## Creates CloudWatch alarms for policies ##
############################################
resource "aws_cloudwatch_metric_alarm" "ecs_alarm_increase_instances" {
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.ecs_policy_increase_instances.arn}"]
  alarm_description   = "This alarm shows excesive ECS CPU Reservation"
  alarm_name          = "asg-alarm-ecs-cpu-increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    "ClusterName" = "${var.ecs_name}"
  }

  evaluation_periods = "${var.ecs_asg_increase_evaluation_periods}"
  metric_name        = "${var.ecs_asg_increase_metric_name}"
  namespace          = "${var.ecs_asg_increase_namespace}"
  period             = "${var.ecs_asg_increase_periods}"
  statistic          = "${var.ecs_asg_increase_statistic}"
  threshold          = "${var.ecs_asg_increase_threshold}"
}

resource "aws_cloudwatch_metric_alarm" "ecs_alarm_decrease_instances" {
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.ecs_policy_decrease_instances.arn}"]
  alarm_description   = "This alarm shows less ECS CPU Reservation"
  alarm_name          = "asg-alarm-ecs-cpu-decrease"
  comparison_operator = "LessThanOrEqualToThreshold"

  dimensions = {
    "ClusterName" = "${var.ecs_name}"
  }

  evaluation_periods = "${var.ecs_asg_decrease_evaluation_periods}"
  metric_name        = "${var.ecs_asg_decrease_metric_name}"
  namespace          = "${var.ecs_asg_decrease_namespace}"
  period             = "${var.ecs_asg_decrease_periods}"
  statistic          = "${var.ecs_asg_decrease_statistic}"
  threshold          = "${var.ecs_asg_decrease_threshold}"
}

/*
###############################
## Define ELBs for the services
###############################
resource "aws_elb" "rails_frontend" {
  name = "rails-frontend-elb"
  cross_zone_load_balancing = true
  #availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  subnets = ["${var.subnets}"]

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 3000
    instance_protocol = "http"
  }
}

resource "aws_elb" "sinatra_backend" {
  name = "sinatra-backend-elb"
  cross_zone_load_balancing = true
  #availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  subnets = ["${var.subnets}"]

  listener {
    lb_port = 4567
    lb_protocol = "http"
    instance_port = 4567
    instance_protocol = "http"
  }
}

###############################
## Define IAM Roles for the services
###############################
/*resource "aws_iam_role" "ecs_role_rails_frontend" {
  name = "ecs-role-rails-frontend"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_role_sinatra_backend" {
  name = "ecs-role-sinatra-backend"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
*/
