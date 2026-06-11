variable "db_password" {
  description = "RDS MySQL 마스터 비밀번호"
  type        = string
  sensitive   = true
}

variable "my_ip" {
  description = "내 로컬 PC IP 주소"
  type        = string
  default     = "119.192.31.35/32" # 사용자님 IP 고정!
}

variable "aws_region" {
  default = "ap-northeast-2"
}