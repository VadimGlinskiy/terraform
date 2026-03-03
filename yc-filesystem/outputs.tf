output "id" {
  value       = yandex_compute_filesystem.this.id
  description = "The ID of the filesystem."
}

output "name" {
  value       = yandex_compute_filesystem.this.name
  description = "The name of the filesystem."
}

output "created_at" {
  value       = yandex_compute_filesystem.this.created_at
  description = "Creation timestamp of the filesystem."
}