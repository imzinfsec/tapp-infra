module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "tapp-cluster"
  cluster_version = "1.31"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.my_ip] # 지적해주신 대로 고정 IP 원복

  eks_managed_node_groups = {
    tapp-node-group = {
      instance_types = ["m7i-flex.large"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }
  }

  enable_cluster_creator_admin_permissions = true 
}