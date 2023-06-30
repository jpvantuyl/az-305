Describe 'Application Insights' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $ap = "$rg-app"
        $appInsightName = "$ap-appi"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                location       = $location
                appName        = $ap
                appInsightName = $appInsightName
                email          = $email
            }
        }
        Contemplate-AzResources @splat
        $applicationInsights = Get-AzApplicationInsights -Name $appInsightName -ResourceGroupName $rg -Full
    }

    It 'should be capped' {
        $applicationInsights.IsCapped | Should -Be $false
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}