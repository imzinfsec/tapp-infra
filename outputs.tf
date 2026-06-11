# outputs.tf

output "rds_endpoint" {
  description = "스프링 부트(application.yml)에 넣을 데이터베이스 연결 주소"
  value       = aws_db_instance.mysql.endpoint
}

output "ecr_repository_url" {
  description = "도커 이미지를 Push할 ECR 저장소 주소"
  value       = aws_ecr_repository.tapp_app_repo.repository_url
}

output "github_actions_role_arn" {
  description = "깃허브 액션 스크립트에 넣을 OIDC Role ARN"
  value       = aws_iam_role.github_actions_role.arn
}