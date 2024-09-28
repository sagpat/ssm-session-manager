#  Please comment / uncomment each module to run and test.

module "natgw-connectivity" {
  source = "./natgw-connectivity"
}

module "vpc-endpoints-connectivity" {
  source = "./vpc-endpoints-connectivity"
}