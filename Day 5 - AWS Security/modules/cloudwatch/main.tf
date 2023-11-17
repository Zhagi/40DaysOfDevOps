resource "aws_sns_topic" "example_topic" {
  name = "example-topic"
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "email"  
  endpoint  = "zubaydahagi@gmail.com"  
}


resource "aws_cloudwatch_metric_alarm" "example_alarm" {
  alarm_name          = "zh-cloudwatch-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnauthorisedAPICalls"
  namespace           = "AWS/Logs"
  
  dimensions = {
    LogGroupName = "zh-log-group"
  }

  period    = 300
  statistic = "SampleCount"
  threshold = 1

  alarm_description = "Unauthorised API Calls Alarm"
  alarm_actions     = [aws_sns_topic.example_topic.arn]
}
