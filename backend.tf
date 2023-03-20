# store the terraform state file in s3

terraform {
  backend "s3" {
    bucket         =  "cloudrock-s3project-bucket"
    dynamodb_table =  "terraform-state-lock-dynamo"
    key            =  "cloudrock-projects3.tfstate"
    region         =  "eu-west-2"
    encrypt        = true
    
  }
}
 

