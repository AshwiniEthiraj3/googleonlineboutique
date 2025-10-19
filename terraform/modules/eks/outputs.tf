output "cluster_endpoint" {
  value = aws_eks_cluster.master.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.master.name
}