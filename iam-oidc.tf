# 1. AWS 계정에 깃허브 OIDC 공급자 자체를 생성 (필수!)
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  # 깃허브 인증서 지문 (AWS가 깃허브를 신뢰하기 위한 기본값)
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"] 
}

# 2. 깃허브라는 서비스 자체를 우리 AWS 계정의 신용 안전처로 등록
data "aws_iam_policy_document" "github_allow" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      # 위에서 만든 공급자의 ARN을 참조하도록 수정
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # ⚠️ 내 깃허브 닉네임과 레포지토리 이름으로 들어오는 요청만 허용하는 자물쇠
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:imzinfsec/tapp-app:*"] 
    }
  }
}

# 3. 깃허브 액션이 사용할 역할(Role) 생성
resource "aws_iam_role" "github_actions_role" {
  name               = "tapp-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_allow.json
}

# 4. 이 깃허브 신분증에 ECR에 이미지를 올릴 수 있는 권한 부여
resource "aws_iam_role_policy_attachment" "github_ecr_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}