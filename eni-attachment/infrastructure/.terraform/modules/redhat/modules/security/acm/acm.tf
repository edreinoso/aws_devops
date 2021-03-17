resource "aws_acm_certificate" "cert" {
  domain_name               = "${var.domain-name}"
  subject_alternative_names = "${var.subject-alternative-names}"
  validation_method         = "${var.validation-method}"

  tags = {
    Name          = "${var.name}"
    Environment   = "${terraform.workspace}"
    Template      = "${var.template}"
    Application   = "${var.application}"
    Purpose       = "${var.purpose}"
    Creation_Date = "${var.created-on}"
  }

  lifecycle {
    create_before_destroy = true
  }
}