
resource "aws_security_group" "grp1-eks-sg" {
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "Created from terraform"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_eks_cluster" "grp1-eks-cluster" {
  name     = "grp1-eks-cluster"
  role_arn = aws_iam_role.grp1-eks-role.arn

  vpc_config {
    subnet_ids         = data.aws_subnet_ids.default_subnet.ids
    security_group_ids = [aws_security_group.grp1-eks-sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.grp1-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.grp1-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "grp1-eks-node-group" {
  cluster_name    = aws_eks_cluster.grp1-eks-cluster.name
  node_group_name = "grp1-eks-node-group"
  node_role_arn   = aws_iam_role.grp1-eks-worker-role.arn
  subnet_ids      = data.aws_subnet_ids.default_subnet.ids
  instance_types = [var.instance_type_t3]
  ami_type = var.ami_type
  disk_size = "20"
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.grp1-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.grp1-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.grp1-AmazonEC2ContainerRegistryReadOnly,
  ]
}