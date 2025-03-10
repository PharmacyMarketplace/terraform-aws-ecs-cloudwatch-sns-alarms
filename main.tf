module "cpu_utilization_high_alarm_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["cpu", "utilization", "high"]

  context = module.this.context
}

module "cpu_utilization_low_alarm_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["cpu", "utilization", "low"]

  context = module.this.context
}

module "memory_utilization_high_alarm_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["memory", "utilization", "high"]

  context = module.this.context
}

module "memory_utilization_low_alarm_label" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = ["memory", "utilization", "low"]

  context = module.this.context
}

locals {
  thresholds = {
    CPUUtilizationHighThreshold    = min(max(var.cpu_utilization_high_threshold, 0), 100)
    CPUUtilizationLowThreshold     = min(max(var.cpu_utilization_low_threshold, 0), 100)
    MemoryUtilizationHighThreshold = min(max(var.memory_utilization_high_threshold, 0), 100)
    MemoryUtilizationLowThreshold  = min(max(var.memory_utilization_low_threshold, 0), 100)
  }

  dimensions_map = {
    "service" = {
      "ClusterName" = var.cluster_name
      "ServiceName" = var.service_name
    }
    "cluster" = {
      "ClusterName" = var.cluster_name
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  count               = module.this.enabled && local.thresholds["CPUUtilizationHighThreshold"] > 0 ? 1 : 0
  alarm_name          = module.cpu_utilization_high_alarm_label.id
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cpu_utilization_high_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cpu_utilization_high_period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationHighThreshold"]

  alarm_description = format(
    var.alarm_description,
    "CPU",
    "High",
    var.cpu_utilization_high_period / 60,
    var.cpu_utilization_high_evaluation_periods
  )

  alarm_actions = compact(var.cpu_utilization_high_alarm_actions)
  ok_actions    = compact(var.cpu_utilization_high_ok_actions)

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  count               = module.this.enabled && local.thresholds["CPUUtilizationLowThreshold"] > 0 ? 1 : 0
  alarm_name          = module.cpu_utilization_low_alarm_label.id
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cpu_utilization_low_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cpu_utilization_low_period
  statistic           = "Maximum"
  threshold           = local.thresholds["CPUUtilizationLowThreshold"]

  alarm_description = format(
    var.alarm_description,
    "CPU",
    "Low",
    var.cpu_utilization_low_period / 60,
    var.cpu_utilization_low_evaluation_periods
  )

  alarm_actions = compact(var.cpu_utilization_low_alarm_actions)
  ok_actions    = compact(var.cpu_utilization_low_ok_actions)

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  count               = module.this.enabled && local.thresholds["MemoryUtilizationHighThreshold"] > 0 ? 1 : 0
  alarm_name          = module.memory_utilization_high_alarm_label.id
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.memory_utilization_high_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.memory_utilization_high_period
  statistic           = "Average"
  threshold           = local.thresholds["MemoryUtilizationHighThreshold"]

  alarm_description = format(
    var.alarm_description,
    "Memory",
    "High",
    var.memory_utilization_high_period / 60,
    var.memory_utilization_high_evaluation_periods
  )

  alarm_actions = compact(var.memory_utilization_high_alarm_actions)
  ok_actions    = compact(var.memory_utilization_high_ok_actions)

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_low" {
  count               = module.this.enabled && local.thresholds["MemoryUtilizationLowThreshold"] > 0 ? 1 : 0
  alarm_name          = module.memory_utilization_low_alarm_label.id
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.memory_utilization_low_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.memory_utilization_low_period
  statistic           = "Average"
  threshold           = local.thresholds["MemoryUtilizationLowThreshold"]

  alarm_description = format(
    var.alarm_description,
    "Memory",
    "Low",
    var.memory_utilization_low_period / 60,
    var.memory_utilization_low_evaluation_periods
  )

  alarm_actions = compact(var.memory_utilization_low_alarm_actions)
  ok_actions    = compact(var.memory_utilization_low_ok_actions)

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}
