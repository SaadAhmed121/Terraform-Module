resource "aws_instance" "database_instance"{
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
                sudo apt install awscli -y
                sudo aws s3 sync s3://saaddb/ /home/ubuntu
                sudo apt install mysql-server mysql-client -y
              
                sudo sed -i 's/mysqlx/#mysqlx/' /etc/mysql/mysql.conf.d/mysqld.cnf
                sudo sed -i 's/bind-address/#bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
                sudo service mysql restart
                sudo mysqladmin -uroot  create 'elms'
                sudo mysql -uroot -psaadsaad -e "CREATE USER 'saad'@'%' IDENTIFIED BY 'saadsaad';"
                sudo mysql -uroot -psaadsaad -e "GRANT ALL PRIVILEGES ON elms.* TO 'saad'@'%';"
                sudo mysql -uroot -psaadsaad -e "FLUSH PRIVILEGES;"
                sudo mysql -u saad -psaadsaad elms < /home/ubuntu/elms.sql
     EOF
    tags = {
        Name= "Saad-Database_instance"
    }
}