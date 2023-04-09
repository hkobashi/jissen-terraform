provider "aws" {
  region = "ap-northeast-1"
}

variable "waf" {
    type = map(string)
    default = {
        "default.waf_for_alb"                     = "waf-for-alb"
        "dev.waf_for_alb"                         = "waf-for-alb-dev"
        "stg.waf_for_alb"                         = "waf-for-alb-stg"
        "prd.waf_for_alb"                         = "waf-for-alb-prd"

        "default.cloudwatch_metrics"              = "waf-metrics"
        "dev.cloudwatch_metrics"                  = "waf-metrics-dev"
        "stg.cloudwatch_metrics"                  = "waf-metrics-stg"
        "prd.cloudwatch_metrics"                  = "waf-metrics-prd"
    }
}


resource "aws_wafv2_web_acl" "waf_for_alb" {
  name            = "${lookup(var.waf, "${terraform.workspace}.waf_for_alb", var.waf["default.waf_for_alb"])}-${terraform.workspace}"
  description = "waf_for_alb"
  scope       = "REGIONAL"

  # wafで定義したルールに該当しないアクセスを許可する
  default_action {
    allow {}
  }

  rule {
    name     = "bot-control"
    priority = 1
    override_action {
      count {}
    }
    statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"
          # Bot-Control設定
          managed_rule_group_configs {
            aws_managed_rules_bot_control_rule_set {
              inspection_level = "COMMON"
            }
          }
        rule_action_override {
          name = "CategoryAdvertising"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategoryArchiver"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategoryContentFetcher"
          action_to_use {
          block {}
          }
        }
        rule_action_override {
          name = "CategoryEmailClient"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategoryHttpLibrary"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategoryLinkChecker"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategoryMiscellaneous"
          action_to_use {
          block {}
          }
        }
        rule_action_override {
          name = "CategoryMonitoring"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategoryScrapingFramework"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategorySearchEngine"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategorySecurity"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategorySeo"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "CategorySocialMedia"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "SignalAutomatedBrowser"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "SignalKnownBotDataCenter"
          action_to_use {
            block {}
          }
        }
        rule_action_override {
          name = "SignalNonBrowserUserAgent"
          action_to_use {
            block {}
          }
        }
    }
  }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${lookup(var.waf, "${terraform.workspace}.cloudwatch_metrics", var.waf["default.cloudwatch_metrics"])}-${terraform.workspace}"
      sampled_requests_enabled   = false
  }
}

  # CloudWatchにWAFの動作状況を表示
  visibility_config {
  cloudwatch_metrics_enabled = true
  metric_name                = "${lookup(var.waf, "${terraform.workspace}.cloudwatch_metrics", var.waf["default.cloudwatch_metrics"])}-${terraform.workspace}"
  sampled_requests_enabled   = false
  }
}