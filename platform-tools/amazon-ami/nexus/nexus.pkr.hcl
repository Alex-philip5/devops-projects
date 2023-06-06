variable "ami_id" {
  type    = string
  default = "ami-0735c191cf914754d"
}

locals {
    app_name = "nexus"
}

source "amazon-ebs" "nexus" {
  ami_name      = "packer-${local.app_name}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "dev"
    Name = "${local.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.nexus"]

  provisioner "ansible" {
    playbook_file = "nexus.yml"
    extra_vars = {
      consul_server_address = var.consul.server.ip
    }
  }

}
