resource "yandex_compute_filesystem" "this" {
  name        = var.fs_name
  description = var.fs_description
  type        = var.fs_type
  zone        = var.fs_zone
  size        = var.fs_size
  folder_id   = var.folder_id
  labels      = var.fs_labels
}