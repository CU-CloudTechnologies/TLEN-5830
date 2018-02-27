#Upload the public key on AWS

resource "aws_key_pair" "default" {
	key_name = "vpc_keypair"
	public_key = "${file("${var.key_path}")}"
}
