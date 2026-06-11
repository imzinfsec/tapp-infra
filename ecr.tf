resource "aws_ecr_repository" "tapp_app_repo" {
  name                 = "tapp-app" # 도커 이미지가 저장될 저장소 이름
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # 이미지 업로드 시 보안 취약점 자동 검사
  }
}