resource "aws_launch_configuration" "saad-launchconfig" {
    name_prefix = "saad-launchconfig"
    associate_public_ip_address = "true"
    image_id = "ami-09e67e426f25ce0d7"
    iam_instance_profile = "${var.iam}"
    instance_type = "t2.micro"
    key_name = "saad"
    depends_on = [var.DB_IP]
    security_groups = ["${var.sg}"]
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install lamp-server^ -y
                sudo chown -R $USER:$USER /var/www/html
                sudo apt install awscli -y
                sudo aws s3 sync s3://saadsshkey/ /home/ubuntu
                sudo aws s3 sync s3://saadelms/ /var/www/html
                sudo sed -i 's/null/${var.DB_IP}/' /var/www/html/elms/includes/config.php
                sudo sed -i 's/Welcome to ELMS/Welcome to ELMS Server/' /var/www/html/elms/index.php
     EOF
   
}

resource "aws_autoscaling_group" "saad-autoscaling" {
    name= "saad-autoscaling"
    vpc_zone_identifier = ["${var.subnet}","${var.subnet2}"]
    launch_configuration = "${aws_launch_configuration.saad-launchconfig.name}"
    min_size= 2
    max_size = 3
    health_check_grace_period = 300
    health_check_type = "ELB"
    load_balancers = ["${var.LB}"]

    force_delete = true 
    
    tag {
      key= "Name"
      value= "Saad-Web-Instance"
      propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "saad_autoscalingpolicy" {
    name= "saad_autoscalingpolicy"
    autoscaling_group_name = "${aws_autoscaling_group.saad-autoscaling.name}"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "1"
    cooldown = "300"
    policy_type = "SimpleScaling"
} 

resource "aws_cloudwatch_metric_alarm" "saad-cloudwatch" {
    alarm_name = "saad-cloudwatch"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "30"
    dimensions = {
      "AutoScalingGroupName" = "${aws_autoscaling_group.saad-autoscaling.name}"
    }

    actions_enabled = true
    alarm_actions = ["${aws_autoscaling_policy.saad_autoscalingpolicy.arn}"]
}

    