variable "cluster-name" {
  default = "terraform-dev-charleslin"
  type    = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
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
