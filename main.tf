module "vpcModule" {

source = "./modules/vpcModule"

}


module "ec2module" {

source = "./modules/ec2module"
vpc = module.vpcModule.vpc
demo_subnet1= module.vpcModule.demo_subnet1
demo_subnet2= module.vpcModule.demo_subnet2
demo_subnet_private= module.vpcModule.demo_subnet_private
vpc_security_group = [module.vpcModule.vpc_security_group]
}

module "storage" {

source = "./modules/storage"
}



resource "aws_dynamodb_table" "demo_lock" {
  name             = "terraform-lock-table"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

}

