resource "aws_instance" "web_instance" {
    ami = "ami-09e67e426f25ce0d7"
    instance_type = "t2.micro"
    iam_instance_profile = "${var.iam}"
    associate_public_ip_address = "true"
    subnet_id = "${var.subnet}"
    vpc_security_group_ids = ["${var.sg}"]
    key_name = "saad" 
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install lamp-server^ -y
                sudo chown -R $USER:$USER /var/www/html
                sudo apt install awscli -y
                sudo aws s3 sync s3://saadsshkey/ /home/ubuntu
                sudo aws s3 sync s3://saadelms/ /var/www/html
                sudo sed -i 's/null/${var.db_ip}' /var/www/html/elms/includes/config.php
                sudo sed -i 's/Welcome to ELMS/Welcome to ELMS Server/' /var/www/html/elms/index.php
     EOF
    tags = {
        Name = "Saad-web_instance"
    }
}
