provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../Dev/storage/"
}