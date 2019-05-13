terraform {
  backend "gcs" {
    bucket = "tf-otus-crawler-project"
    prefix = "production"
  }
}
