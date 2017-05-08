## Define the tasks: one for the front and one for the back
/*resource "aws_ecs_task_definition" "rails_frontend" {
  family = "rails-frontend"
  container_definitions = <<EOF
[{
  "name": "rails-frontend",
  "image": "gruntwork/rails-frontend:v1",
  "cpu": 1024,
  "memory": 768,
  "essential": true,
  "portMappings": [{"containerPort": 3000, "hostPort": 3000}],
  "environment": [{
    "name": "SINATRA_BACKEND_PORT",
    "value": "tcp://${aws_elb.sinatra_backend.dns_name}:4567"
    }]
}]
EOF
}

resource "aws_ecs_task_definition" "sinatra_backend" {
  family = "sinatra-backend"
  container_definitions = <<EOF
[{
  "name": "sinatra-backend",
  "image": "gruntwork/sinatra-backend:v1",
  "cpu": 1024,
  "memory": 768,
  "essential": true,
  "portMappings": [{"containerPort": 4567, "hostPort": 4567}]
}]
EOF
}
*/
