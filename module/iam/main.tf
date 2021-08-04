resource "aws_iam_role_policy" "ec2_policy" {
 name = "ec2_policy"
 role = "${aws_iam_role.test_role.id}"


 policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
    ]
 })

 }


resource "aws_iam_role" "test_role" {
    name= "test_role"
    assume_role_policy =  jsonencode ({
     "Version": "2012-10-17",
     "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        },
    ]
})

   
    
}


resource "aws_iam_instance_profile" "test_profile" {
    name = "test_profile"
    role= "${aws_iam_role.test_role.id}"
}