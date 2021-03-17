module "autoscaling_example" {
  source = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/autoscaling"

  name = "${var.autoscaling-name}-${terraform.workspace}"

  # Launch configuration
  #
  # launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  # create_lc = false # disables creation of launch configuration
  lc_name                      = "${var.launch-configuration-name}-${terraform.workspace}"
  image_id                     = var.ami
  instance_type                = var.instance-type
  security_groups              = split(",", aws_security_group.web-sg.id) #
  associate_public_ip_address  = false
  recreate_asg_when_lc_changes = true
  user_data_base64             = base64encode("${file("build.sh")}")
  key_name                     = var.key-name-pri
  ebs_block_device = [
    {
      device_name           = "/dev/xvdk"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # element(element(element(module.pri_subnet_1.subnet-id, 1), 0),0)

  # Auto scaling group
  asg_name                  = "${var.autoscaling-name}-${terraform.workspace}"
  vpc_zone_identifier       = [element(module.pri_subnet_1.subnet-id, 3), element(module.pri_subnet_2.subnet-id, 3)]
  health_check_type         = var.health-check
  target_group_arns         = [module.target-group.target-arn]
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  wait_for_capacity_timeout = 0
  enabled_metrics           = var.enabled_metrics
  # service_linked_role_arn   = var.role

  tags = [
    {
      key                 = "Environment"
      value               = terraform.workspace
      propagate_at_launch = true
    },
    {
      key                 = "Template"
      value               = var.template
      propagate_at_launch = true
    },
    {
      key                 = "Creation Date"
      value               = var.created-on
      propagate_at_launch = true
    },
    {
      key                 = "Purpose"
      value               = var.purpose
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = var.application
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = var.autoscaling-name
      propagate_at_launch = true
    },
  ]
}

### TRACKING POLICY ###
resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "testing-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = module.autoscaling_example.this_autoscaling_group_name
  estimated_instance_warmup = 200
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      # making this resource label dynamic is going to take a bit of work
      # taking only a certain portion of the elb and tg arn is going to require
      # some shell scripting
      # resource_label = "app/${var.elb-name}/cc726da8048f2ea6/targetgroup/${var.elb-tg-name}/54a0a849fc831919"
      resource_label = "${module.elb.elb-arn-suffix}/${module.target-group.tg-arn-suffix}"
    }
    target_value = "60"
  }
}

### STEP POLICY ###
# resource "aws_autoscaling_policy" "web_cluster_step_policy_scale_out" {
#   name                      = "testing-step-policy-scale_out"
#   autoscaling_group_name    = module.autoscaling_example.this_autoscaling_group_name
#   adjustment_type           = "ChangeInCapacity"
#   policy_type               = "StepScaling"
#   step_adjustment {
#     scaling_adjustment          = 1
#     metric_interval_lower_bound = 0
#     metric_interval_upper_bound = 15
#   }
#   step_adjustment {
#     scaling_adjustment          = 2
#     metric_interval_lower_bound = 15
#     metric_interval_upper_bound = 25
#   }
#   step_adjustment {
#     scaling_adjustment          = 3
#     metric_interval_lower_bound = 25
#   }
# }

# resource "aws_autoscaling_policy" "web_cluster_step_policy_scale_in" {
#   name                      = "testing-step-policy-scale_in"
#   autoscaling_group_name    = module.autoscaling_example.this_autoscaling_group_name
#   adjustment_type           = "ChangeInCapacity"
#   policy_type               = "StepScaling"
#   step_adjustment {
#     scaling_adjustment          = -1
#     metric_interval_lower_bound = -5
#     metric_interval_upper_bound = 0
#   }
#   step_adjustment {
#     scaling_adjustment          = -2
#     metric_interval_lower_bound = -7.5
#     metric_interval_upper_bound = -5
#   }
#   step_adjustment {
#     scaling_adjustment          = -3
#     metric_interval_upper_bound = -7.5
#   }
# }

### SIMPLE SCALING ###
# # autoscaling policy to measure Cpu metrics to scale up by 1 server
# resource "aws_autoscaling_policy" "web_cluster_simple_policy_scale_out" {
#   name                   = "example-cpu-policy-scaleup"
#   autoscaling_group_name = module.example.this_autoscaling_group_name
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "1"
#   cooldown               = "60"
#   policy_type            = "SimpleScaling"
# }

# # autoscaling measure to scale down by 1 server
# resource "aws_autoscaling_policy" "web_cluster_simple_policy_scale_in" {
#   name                   = "example-cpu-policy-scaledown"
#   autoscaling_group_name = module.example.this_autoscaling_group_name # module.new-vpc.vpc-id}"
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "-1"
#   cooldown               = "60"
#   policy_type            = "SimpleScaling"
# }

## CLOUDWATCH ##
# This is necessary for step and simple scaling policies
# resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scale_out" {
#   alarm_name          = "example-cpu-alarm-scaleup"
#   alarm_description   = "example-cpu-alarm-scaleup"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "70"
#   dimensions = {
#     "AutoScalingGroupName" = module.autoscaling_example.this_autoscaling_group_name
#   }
#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.web_cluster_step_policy_scale_out.arn}"]
# }

# resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scale_in" {
#   alarm_name          = "example-cpu-alarm-scaledown"
#   alarm_description   = "example-cpu-alarm-scaledown"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "10"
#   dimensions = {
#     "AutoScalingGroupName" = module.autoscaling_example.this_autoscaling_group_name # need to get this value
#   }
#   actions_enabled = true
#   alarm_actions   = [aws_autoscaling_policy.web_cluster_step_policy_scale_in.arn}"]
# }
