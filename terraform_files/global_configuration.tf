provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["/home/mohamedmamdouh/.aws/config"]
  shared_credentials_files = ["/home/mohamedmamdouh/.aws/credentials"]

}

# terraform {
#   backend "s3" {
#     bucket                  = "terraform-ansible-s3-bucket-mm-2023"
#     key                     = "terrform.tfstate"
#     region                  = "us-east-1"
#     shared_credentials_file = "/home/mohamedmamdouh/.aws/credentials"
#     dynamodb_table          = "terraform-ansible-DynamoDB-table-mm-2023"
#   }
# } #TODO 
