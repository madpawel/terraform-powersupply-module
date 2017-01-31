# IAM role + policy that grants Lambda permissons to assume roles
data "template_file" "powersupply_role_trust" {
    template = "${file("${path.module}/templates/lambda_policy_trust.json.tpl")}"
    vars {
      env_name = "${var.env_name}"
      action   = "${var.action}"
    }
}

data "template_file" "powersupply_policy" {
    template = "${file("${path.module}/templates/lambda_policy.json.tpl")}"
    vars {
      env_name = "${var.env_name}"
      action   = "${var.action}"
    }
}

resource "aws_iam_role" "powersupply" {
  name               = "powersupply-${var.action}-${var.env_name}"
  assume_role_policy = "${data.template_file.powersupply_role_trust.rendered}"
}

resource "aws_iam_role_policy" "powersupply" {
  name   = "powersupply-${var.env_name}-iam-policy"
  role   = "${aws_iam_role.powersupply.id}"
  policy = "${data.template_file.powersupply_policy.rendered}"
}
