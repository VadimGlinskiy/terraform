variable "yc_token" {
  type        = string
  description = "Yandex Cloud static access key."
  sensitive   = true # Помечаем токен как чувствительные данные
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud ID."
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID for provider configuration."
}

variable "yc_zone" {
  type        = string
  description = "Yandex Cloud default availability zone for provider."
}

variable "folder_id" {
  type        = string
  description = "ID of the folder to create the filesystem in. Must be passed explicitly for the resource."
}

variable "fs_name" {
  type        = string
  description = "Name of the filesystem."
}

variable "fs_zone" {
  type        = string
  description = "The availability zone where the filesystem will be created."
}

variable "fs_size" {
  type        = number
  description = "The size of the filesystem in GB."
}

variable "fs_type" {
  type        = string
  description = "Type of the filesystem. Can be 'network-hdd' or 'network-ssd'."
  default     = "network-hdd"
}

variable "fs_description" {
  type        = string
  description = "An optional description of the filesystem."
  default     = ""
}

variable "block_size" {
  type        = number
  description = "The block size of the filesystem in bytes."
  default     = 4096
}

variable "fs_labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the filesystem."
  default     = {}
}