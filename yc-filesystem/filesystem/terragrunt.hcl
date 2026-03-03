terraform {
source = "../yc-filesystem"
}

include {
  path = find_in_parent_folders()
}

locals {
  folder_vars = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  folder_name = basename(dirname(dirname(get_terragrunt_dir())))
}

dependencies {
  paths = ["../../network"]
}

inputs = {
  yc_token     = local.common_vars.locals.yc_token
  yc_cloud_id  = local.common_vars.locals.yc_cloud_id
  yc_folder_id = local.folder_vars.locals.yc_folder_id
  yc_zone      = "ru-central1-b" # Зона для конфигурации провайдера по умолчанию
  folder_id      = local.folder_vars.locals.yc_folder_id # Явное указание папки для самого ресурса
  fs_zone        = "ru-central1-b" # Явное указание зоны для самого ресурса
  fs_name        = "project"
  fs_description = "File storage for project"
  fs_type        = "network-ssd"
  fs_size        = 500
  block_size     = 4096

  # Метки для создаваемого ресурса
  fs_labels = {
    namespace   = "project",
    stand       = "prod"
  }
}