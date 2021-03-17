resource "aws_network_acl_rule" "rules" {
  count  = "${length(var.cidr-block)}"
  network_acl_id = "${var.nacls-id}"
  rule_number    = "${element(var.rule-no, count.index)}"
  egress         = "${element(var.egress, count.index)}"
  protocol       = "${var.protocol}"
  rule_action    = "${element(var.action, count.index)}"
  cidr_block     = "${element(var.cidr-block, count.index)}"
  from_port      = "${var.from-port}"
  to_port        = "${var.to-port}"
}