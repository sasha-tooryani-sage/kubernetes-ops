terraform {
  backend "remote" {
    organization = "intacct"

    workspaces {
      name = "tf-usw-ovpn-instances-group1"
    }
  }
}
