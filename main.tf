terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
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
  network_id     = "${yandex_vpc_network.terraform-network.id}"
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
    subnet_id = "${yandex_vpc_subnet.terraform-network-subnet.id}"
  }

  metadata = {
    ssh-keys = "vadim:${file("~/.ssh/id_rsa.pub")}"
  }
}