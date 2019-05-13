# resource "google_storage_bucket" "storage-bucket" {
#   name = "tf-otus-crawler-project"
#   location = "EU"
#   storage_class = "REGIONAL"
#   force_destroy = true
# }
# resource "google_storage_bucket_acl" "tf-otus-crawler-project-acl" {
#   bucket         = "${google_storage_bucket.storage-bucket.name}"
#   predefined_acl = "publicreadwrite"
# }

