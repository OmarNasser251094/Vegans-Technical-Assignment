variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Number of instances to run"
  type        = number
  default     = 2
}

variable "subnets" {
  description = "Subnets for the ECS service"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for the ECS task"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}

variable "github_token" {
  description = "GitHub OAuth token for accessing the repository"
  type        = string
  // It's a good practice not to set a default value for sensitive information
  sensitive   = true
}