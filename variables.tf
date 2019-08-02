variable "vpc_id" {
  description = "VPC ID"
}

variable "subnets" {
  description = "A list of subnets to deploy ECS instances."
  type = "list"
  #default = [ "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24" ]
}

variable "ecs_keypair" {
  description = "Keypair to attach to instances in ASG group"
  default = "ecs-keypair"
}

variable "ecs_keypair_public_key" {
  description = "Public key of the keypair"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFZoVbh8sv10WzZwSH+wQsze38Pdgjek3dsj9nm3puS85OYq1FFBCnqEZo87cdZPdkiHjyrZqS4FvXybropNBBQJ3hsut/XTj4LF+gt+NaXLsjMXkTYyth07h4ToyXPaFFMY7SO7vr/gsxLWdK0O4HkpvDgvTI/2pyommkiEiKkH9igriDshp6czWQtdmT1aJXZN4hQI6i1lrUK3YYgBywIz2iCuHcHIHxVdthI9Eoh7SMul6bE4yXJXpjxj8DF9qmX2SmO6ETlq9KfIDckZjWroezB/bOxjDHr9PyfHCvoU9Ura+igvsVyi4YztyBVYPHEX4iMJaFy2ZJ0f9iTfvx"
}

variable "ecs_name"{
  description = "Cluster Name"
  default = "ecs-cluster"
}

variable "ecs_asg_min_size" {
  description = "ASG's min size"
  default = 1
}

variable "ecs_asg_max_size" {
  description = "ASG's max size"
  default = 3
}

variable "ecs_asg_lc_instance_type" {
  description = "Launch Configuration Instance Type"
  default = "t2.small"
}

variable "ecs_asg_lc_image_id" {
  description = "Launch Configuration Image ID"
  default = "ami-95f8d2f3"
}

#################################
## Variables for the ASG policies
#################################
variable "ecs_asg_increase_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "3"
}

variable "ecs_asg_increase_metric_name" {
  description = "Name for the alarm's associated metric."
  default = "CPUReservation"
}

variable "ecs_asg_increase_namespace" {
  description = "The namespace for the alarm's associated metric."
  default     = "AWS/ECS"
}

variable "ecs_asg_increase_periods" {
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "ecs_asg_increase_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Valid values are 'SampleCount', 'Average', 'Sum', 'Minimum' and 'Maximum'"
  default     = "Average"
}

variable "ecs_asg_increase_threshold" {
  description = "The value against which the specified statistic is compared."
  default     = "80"
}



variable "ecs_asg_decrease_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "10"
}

variable "ecs_asg_decrease_metric_name" {
  description = "Name for the alarm's associated metric."
  default = "CPUReservation"
}

variable "ecs_asg_decrease_namespace" {
  description = "The namespace for the alarm's associated metric."
  default     = "AWS/ECS"
}

variable "ecs_asg_decrease_periods" {
  description = "The period in seconds over which the specified statistic is applied."
  default     = "300"
}

variable "ecs_asg_decrease_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Valid values are 'SampleCount', 'Average', 'Sum', 'Minimum' and 'Maximum'"
  default     = "Average"
}

variable "ecs_asg_decrease_threshold" {
  description = "The value against which the specified statistic is compared."
  default     = "30"
}
