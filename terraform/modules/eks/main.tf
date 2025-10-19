resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-cluster-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "master" {
  name = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.cluster_role.arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  depends_on = [ aws_iam_role_policy_attachment.cluster_policy ]
}

resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-node-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.value
  role = aws_iam_role.node_role.name
}

resource "aws_eks_node_group" "worker" {
  for_each = var.node_groups
  cluster_name = aws_eks_cluster.master.name
  node_group_name = each.key
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids = var.subnet_ids

  instance_types = each.value.instance_types
  capacity_type = each.value.capacity_type

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    max_size = each.value.scaling_config.max_size
    min_size = each.value.scaling_config.min_size
  }

  depends_on = [ aws_iam_role_policy_attachment.node_policy ]
}