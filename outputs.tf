output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.example_cluster.id}"
}

output "ecs_sg_id" {
  value = "${aws_security_group.allow_internal_traffic.id}"
}
