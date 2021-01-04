variable "AWS_REGIONS" {
  default = "us-east-1"
}

## DDB

  variable "table-name" {
    type    = "string"
    default = "EBS_Encryption"
  }

  variable "primary-key" {
    type    = "string"
    default = "IVoId"
  }

  variable "attribute-type" {
    type    = "string"
    default = "S"
  }

  variable "read-write-capacity" {
    type    = "string"
    default = "5"
  }

  variable "billing" {
    type    = "string"
    default = "PROVISIONED"
  }

  variable "streams" {
    type    = "string"
    default = "false"
  }

  variable "ttl-enabled" {
    type    = "string"
    default = "false"
  }

## KMS
  variable "key-description" {
    type = "string"
    default = "Key will be used for the encryption of EBS volumes"
  }

## IAM
  variable "ebs-encryption-iam" {
    type = "string"
    default = "EBS_Encryption"
  }

## LAMBDA
  
  variable "file-name" {
    type = "map"
    default = {
      taker = "taker.zip"
      creator  = "creator.zip"
      remover  = "remover.zip"
    }
  }

  variable "function-name" {
    type = "map"
    default = {
      taker = "snapshot-taker-ebs-encryption"
      creator  = "volume-creator-ebs-encryption"
      remover  = "volume-remover-ebs-encryption"
    }
  }

  variable "handler" {
    type    = "map"
    default = {
      taker = "snapshot_taker.lambda_handler"
      creator = "volume_creator.lambda_handler"
      remover = "volume_remover.lambda_handler"
    }
  }

  variable "timeout" {
    type    = "map"
    default = {
      taker = "120"
      creator = "180"
      remover = "90"
    }
  }

  variable "role" {
    type    = "string"
    default = "arn:aws:iam::130193131803:role/LambdaEC2FullAccess"
  }

  variable "runtime" {
    type    = "string"
    default = "python2.7"
  }

  variable "memory-size" {
    type    = "string"
    default = "128"
  }

