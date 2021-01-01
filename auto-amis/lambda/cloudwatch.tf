# currently in development
# resource "aws_cloudwatch_event_target" "example" {
#   arn  = "${module.taker_function.arn}"
#   rule = "${aws_cloudwatch_event_rule.console.id}"
# }

# resource "aws_cloudwatch_event_rule" "console" {
#   name        = "auto_ami_cloudwatch_event"
#   description = "Taking and deleting AMIs in a certain frequency"
#   schedule_expression = "cron(0/15 * * * ? *)" # frequency of event
# }
