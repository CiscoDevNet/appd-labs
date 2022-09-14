variable "cluster-name" {
  default = "lab-cluster"
  type    = string
}

variable "region" {
  description = "AWS region to deploy to"
  default     = "us-west-1"
  type        = string
}

variable "cost-center-tags" {
  type = map
  description = "tags needed for PS AWS Account"
  default =  {
    ResourceOwner         = "user@cisco.com"
    JIRAProject           = "JIRA Project Here"
    DataClassification    = "Cisco Confidential"
    CreatedBy             = "user@cisco.com"
    CostCenter            = "Users Cost Center here"
    Exception             = "NA"
    JIRACreation          = "JIRA Ticket Number here"
    SecurityReview        = "NA"
    DeploymentEnvironment = "Sandbox"
  }
}
