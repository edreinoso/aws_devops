resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [
    module.autoscaling_example.this_autoscaling_group_name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.example.arn
}

resource "aws_sns_topic" "example" {
  name = "example-topic"

  # arn is an exported attribute
}


resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = "edgardojesus16@gmail.com"
}