targetScope = 'resourceGroup'

param policyName string

resource frontDoorWafPolicy 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies@2022-05-01' = {
  name: policyName

  location: 'Global'

  sku: {
    name: 'Premium_AzureFrontDoor'
  }

  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Detection'
      requestBodyCheck: 'Enabled'
    }
    customRules: {
      rules: [
        {
          name: 'RateLimitCustomRule'
          enabledState: 'Enabled'
          priority: 100
          ruleType: 'RateLimitRule'
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 250
          matchConditions: [
            {
              matchVariable: 'RemoteAddr'
              operator: 'IPMatch'
              negateCondition: false
              matchValue: [
                '0.0.0.0'
              ]
              transforms: []
            }
          ]
          action: 'Block'
        }
        {
          name: 'BlockNorthKoreaCustomRule'
          enabledState: 'Enabled'
          priority: 110
          ruleType: 'MatchRule'
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 100
          matchConditions: [
            {
              matchVariable: 'RemoteAddr'
              operator: 'GeoMatch'
              negateCondition: false
              matchValue: [
                'KP'
              ]
              transforms: []
            }
          ]
          action: 'Block'
        }
      ]
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'Microsoft_DefaultRuleSet'
          ruleSetVersion: '2.1'
          ruleSetAction: 'Block'
          ruleGroupOverrides: [
            {
              ruleGroupName: 'PHP'
              rules: [
                {
                  ruleId: '933140'
                  enabledState: 'Disabled'
                  action: 'AnomalyScoring'
                  exclusions: []
                }
                {
                  ruleId: '933130'
                  enabledState: 'Disabled'
                  action: 'AnomalyScoring'
                  exclusions: []
                }
                {
                  ruleId: '933120'
                  enabledState: 'Disabled'
                  action: 'AnomalyScoring'
                  exclusions: []
                }
                {
                  ruleId: '933110'
                  enabledState: 'Disabled'
                  action: 'AnomalyScoring'
                  exclusions: []
                }
                {
                  ruleId: '933100'
                  enabledState: 'Disabled'
                  action: 'AnomalyScoring'
                  exclusions: []
                }
                {
                  ruleId: '933150'
                  enabledState: 'Disabled'
                  action: 'AnomalyScoring'
                  exclusions: []
                }
              ]
              exclusions: []
            }
            {
              ruleGroupName: 'SQLI'
              rules: []
              exclusions: [
                {
                  matchVariable: 'RequestHeaderNames'
                  selectorMatchOperator: 'Equals'
                  selector: 'ignore-this-header-for-sqli'
                }
              ]
            }
            {
              ruleGroupName: 'JAVA'
              rules: [
                {
                  ruleId: '944130'
                  enabledState: 'Enabled'
                  action: 'AnomalyScoring'
                  exclusions: [
                    {
                      matchVariable: 'QueryStringArgNames'
                      selectorMatchOperator: 'Equals'
                      selector: 'exclude-query-1'
                    }
                    {
                      matchVariable: 'QueryStringArgNames'
                      selectorMatchOperator: 'Equals'
                      selector: 'exclude-query-1'
                    }
                  ]
                }
              ]
              exclusions: []
            }
          ]
          exclusions: []
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
          ruleSetAction: 'Block'
          ruleGroupOverrides: []
          exclusions: []
        }
      ]
    }
  }
}
