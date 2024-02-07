output "ecs_cluster_name" {
  value = aws_ecs_cluster.my_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.my_service.name
}

output "db_instance_endpoint" {
  value = aws_db_instance.my_db.endpoint
}