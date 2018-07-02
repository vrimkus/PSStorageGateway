@{
    Severity = @(
        'Error',
        'Warning'
    )
    IncludeRules = @(
        'PSAvoidDefaultValueSwitchParameter',
        'PSMisleadingBacktick',
        'PSMissingModuleManifestField',
        'PSReservedCmdletChar',
        'PSReservedParams',
        'PSShouldProcess',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseApprovedVerbs',
        'PSAvoidUsingAliases',
        'PSUseDeclaredVarsMoreThanAssigments',
        'PSPlaceOpenBrace',
        'PSUseConsistentIndentation',
        'PSUseConsistentWhitespace',
        'PSUseSingularNouns',
        'PSAvoidUsingCmdletAliases',
        'PSAvoidUsingEmptyCatchBlock',
        'PSUseCmdletCorrectly',
        'PSAvoidUsingPositionalParameters',
        'PSAvoidGlobalVars',
        'PSUseDeclaredVarsMoreThanAssignments',
        'PSAvoidUsingInvokeExpression'
    )
    Rules = @{
        PSAvoidUsingCmdletAliases  = @{
            Whitelist = @(
                'Echo', 'echo',
                'Sleep', 'sleep',
                'Sort', 'sort',
                'Where', 'where',
                'Select', 'select',
                'ForEach', 'Foreach', 'foreach'
            )
        }

        PSUseConsistentIndentation = @{
            Enable          = $true
            IndentationSize = 4
        }

        PSUseConsistentWhitespace  = @{
            Enable         = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator  = $false
            CheckSeparator = $true
        }
    }
}