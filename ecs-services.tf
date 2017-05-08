## Define the services associated to tasks
/*resource "aws_ecs_service" "rails_frontend" {
  name            = "rails-frontend"
  cluster         = "${aws_ecs_cluster.example_cluster.id}"
  task_definition = "${aws_ecs_task_definition.rails_frontend.arn}"
  desired_count   = 1
  #iam_role        = "${aws_iam_role.ecs_role_rails_frontend.arn}"

  #load_balancer {
  #  elb_name        = "${aws_elb.rails_frontend.id}"
  #  container_name  = "rails-frontend"
  #  container_port  = 3000
  #}
}

resource "aws_ecs_service" "sinatra_backend" {
  name            = "sinatra-backend"
  cluster         = "${aws_ecs_cluster.example_cluster.id}"

  #task_definition = "${aws_ecs_task_definition.sinatra_backend.arn}"
  task_definition = "${aws_ecs_task_definition.sinatra_backend.family}"
  #task_definition = "${aws_ecs_task_definition.sinatra_backend.family}:${aws_ecs_task_definition.sinatra_backend.revision}"

  desired_count   = 1
  #iam_role        = "${aws_iam_role.ecs_role_sinatra_backend.arn}"

  #load_balancer {
  #  elb_name        = "${aws_elb.sinatra_backend.id}"
  #  container_name  = "sinatra-backend"
  #  container_port  = 4567
  #}
}
*/
