# ## FUNCTION 1 ##

# resource "aws_cloudwatch_event_target" "function_1" {
#   target_id = "function_1"
#   arn       = "${module.function_1.arn}"
#   rule      = "${aws_cloudwatch_event_rule.function_1_console.id}"
# }

# resource "aws_cloudwatch_event_rule" "function_1_console" {
#   name                = "${lookup(var.function-name, "taker")}"
#   description         = "Snapshot taker function in the ebs encryption automation process"
#   schedule_expression = "cron(50 1 * * ? *)" # frequency of event
# }

# resource "aws_lambda_permission" "permissions_1" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${lookup(var.function-name, "taker")}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.function_1_console.arn}"
# }

# ## FUNCTION 2 ##

# resource "aws_cloudwatch_event_target" "function_2" {
#   arn  = "${module.function_2.arn}"
#   rule = "${aws_cloudwatch_event_rule.function_2_console.id}"
# }

# resource "aws_cloudwatch_event_rule" "function_2_console" {
#   name        = "${lookup(var.function-name, "creator")}"
#   description = "Volume creator function in the ebs encryption automation process"
#   schedule_expression = "cron(53 1 * * ? *)" # frequency of event
# }

# resource "aws_lambda_permission" "permissions_2" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${lookup(var.function-name, "creator")}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.function_2_console.arn}"
# }

# # ## FUNCTION 3 ##

# resource "aws_cloudwatch_event_target" "function_3" {
#   arn  = "${module.function_3.arn}"
#   rule = "${aws_cloudwatch_event_rule.function_3_console.id}"
# }

# resource "aws_cloudwatch_event_rule" "function_3_console" {
#   name        = "${lookup(var.function-name, "remover")}"
#   description = "Volume remover function in the ebs encryption automation process"
#   schedule_expression = "cron(58 1 * * ? *)" # frequency of event
# }

# resource "aws_lambda_permission" "permissions_3" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${lookup(var.function-name, "remover")}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.function_3_console.arn}"
# }
