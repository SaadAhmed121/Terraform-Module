resource "aws_elb" "saad-elb" {
    name= "saad-elb"
    subnets = ["${var.subnet}","${var.subnet2}"]
    security_groups = ["${var.sg}"]
    listener {
      instance_port= 80
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:80/"
      interval = 30
    }

    cross_zone_load_balancing = true
    connection_draining = true
    connection_draining_timeout = 400

}