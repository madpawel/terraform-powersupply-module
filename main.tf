data "archive_file" "powersupply_zip" {
    type        = "zip"
    source_file = "${path.module}/files/powersupply.py"
    output_path = "${path.module}/files/powersupply.zip"
}

resource "aws_lambda_function" "power_env" {
  description      = "power-${var.action}-${var.env_name}"
  runtime          = "python2.7"
  filename         = "${path.module}/files/powersupply.zip"
  function_name    = "power-${var.action}-${var.env_name}"
  role             = "${aws_iam_role.powersupply.arn}"
  handler          = "powersupply.lambda_handler"
  source_code_hash = "${data.archive_file.powersupply_zip.output_base64sha256}"
  publish          = "true"
  memory_size      = "128"
  timeout          = "15"
  environment {
    variables = {
      tag_name  = "${var.tag_name}"
      tag_value = "${var.tag_value}"
      action    = "${var.action}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "trigger_action_powersupply" {
  count               = "${var.time == "manual" ? 0 : 1 }"
  name                = "${var.action}-${var.env_name}"
  description         = "${var.action} env ${var.env_name} at ${var.time}"
  schedule_expression = "cron(${var.time})"
}

resource "aws_cloudwatch_event_target" "power_env" {
  count     = "${var.time == "manual" ? 0 : 1 }"
  rule      = "${aws_cloudwatch_event_rule.trigger_action_powersupply.name}"
  target_id = "power-${var.env_name}-target"
  arn       = "${aws_lambda_function.power_env.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  count         = "${var.time == "manual" ? 0 : 1 }"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.power_env.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.trigger_action_powersupply.arn}"
}
