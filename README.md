# Terraform ECS Generator
---

This is a basic terraform module which creates an ECS Cluster inside a VPC with an autoscaling group. It really scales in/out.

It also works very well with github.com/rherranzg/terraform_vpc_generator/ terraform module.

## Usage
---
```hcl
module "ecs" {

  source = "github.com/rherranzg/terraform_ecs_generator/"

  subnets =  [ "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24" ]
  vpc_id  = "vpc-aabb1122"

}
```
