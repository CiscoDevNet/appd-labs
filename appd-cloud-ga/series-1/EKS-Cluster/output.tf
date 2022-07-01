output "account_id" {
  description = "AWS Account ID"
  value = data.aws_caller_identity.current.account_id
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value = aws_eks_cluster.aws_eks.name
}
