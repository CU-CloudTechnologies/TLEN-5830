provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_s3_bucket" "lab1-cloud-tech" {
  bucket = "lab1-cloud-tech"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "main" {
  bucket = "${aws_s3_bucket.lab1-cloud-tech.bucket}"
  source = "files/lab1.php"
  key = "lab1.php"
  acl = "public-read"

  etag   = "${md5(file("files/lab1.php"))}"
}

resource "aws_s3_bucket_object" "db" {
  bucket = "${aws_s3_bucket.lab1-cloud-tech.bucket}"
  source = "files/table.sql"
  key = "table.sql"
  acl = "public-read"

  etag   = "${md5(file("files/table.sql"))}"
}




