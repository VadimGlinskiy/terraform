terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "vadim-terraform-backet"
    region = "ru-central1"
    key    = "terraform1.tfstate"
    shared_credentials_file = "storage.key"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}


provider "yandex" {
  service_account_key_file = "../key.json"
  cloud_id                 = "b1g316ieaomifjl52bp5"
  folder_id                = "b1g7i1ahrh2lvqf17o4t"
  zone                     = "ru-central1-a"
}

resource "yandex_vpc_network" "terraform-network" {
  name = "vadim-network"
}

resource "yandex_vpc_subnet" "terraform-network-subnet" {
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.terraform-network.id
}

resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = yandex_vpc_network.terraform-network.id


  labels = {
    my-label = "my-label-value"
  }

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
    content {
      protocol       = "TCP"
      description    = "rule1 description"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = ingress.value
      to_port        = ingress.value
    }
  }

  egress {
    protocol       = "ANY"
    description    = "rule2 description"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
resource "yandex_vpc_address" "permanent-address" {
  name = "permanent-address"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}


resource "yandex_compute_instance" "terraform-vm" {
  name        = "terraform-vm"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oom38rdtlp4qrv61l"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.terraform-network-subnet.id
    nat            = true
    nat_ip_address = yandex_vpc_address.permanent-address.external_ipv4_address.0.address
  }

  metadata = {
    user-data = "${file("/home/vadim/terraform/config.txt")}"
  }
}

output "external-ip" {
  value = yandex_compute_instance.terraform-vm.network_interface.0.nat_ip_address
}