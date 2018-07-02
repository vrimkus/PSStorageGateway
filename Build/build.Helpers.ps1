Add-Type -Path $PSScriptRoot/lib/HtmlAgilityPack.dll

function BuildClassConfiguration {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Entity,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Request', 'Response', 'DataType')]
        [string] $ClassType
    )

    $web = [HtmlAgilityPack.HtmlWeb]::new()
    $apiReferenceUrl = 'https://docs.aws.amazon.com/storagegateway/latest/APIReference'
    $typeColumnWidth = 0

    $apiEntityName = 'API_{0}' -f $Entity
    $url = '{0}/{1}.html' -f $apiReferenceUrl, $apiEntityName

    $doc = $web.Load($url)

    if ($ClassType -in @('Request', 'Response')) {
        $className = '{0}{1}' -f $Entity, $ClassType
        $id = '{0}_{1}Syntax' -f $apiEntityName, $ClassType
        $classJson = $doc.GetElementbyId($id).NextSibling.NextSibling.InnerText -replace '(?<=\s)boolean', '"bool"'
        $classMetadata = $classJson | ConvertFrom-Json
        $classMembers = $classMetadata.psobject.Properties | ForEach {
            $propertyName = '${0}' -f $_.Name
            $propertyType = if ($_.Value -is [array] -and $_.Name -match '^(?<Type>\w+)List') {
                $isListType = $true
                $type = $Matches['Type']
                $value = $_.Value | Select -First 1
                if ($value.GetType() -eq [System.Management.Automation.PSCustomObject]) {
                    #### List of Complex Type
                    '[List[{0}]]' -f $type
                } else {
                    #### List of Primitive Type
                    '[List[{0}]]' -f $value
                }
            } else {
                $isListType = $false
                '[{0}]' -f $_.Value
            }

            $m = [pscustomobject]@{
                Name         = $_.Name
                PropertyName = $propertyName
                Type         = $propertyType
                IsListType   = $isListType
            }
            $typeWidth = $m.Type.Length + 1
            if ($typeWidth -gt $typeColumnWidth) {
                $typeColumnWidth = $typeWidth
            }

            $m
        }
    } else {
        #### DataType
        $className = $Entity
        $properties = $doc.DocumentNode.SelectNodes('//div[@class="variablelist"]/dl/dt')
        $classMembers = foreach ($property in $properties) {
            $name = $property.DescendantNodes().Where{ $_.Name -eq 'b' }.InnerText.Trim()
            $propertyName = '${0}' -f $name
            $propertyType = $property.NextSibling.NextSibling.InnerText -split "`r`n|`n" |
                Where { $_ -match 'Type:\s+(?<TypeName>[\w ]+)$' } |
                ForEach {
                $t = $Matches['TypeName'].Trim()
                $t = if ($t -match '^Array') {
                    $isListType = $true
                    'List[{0}]' -f ($t -replace 's$' -split '\s')[-1]
                } else {
                    $isListType = $false
                    ($t -replace 'Boolean', 'bool').ToLower()
                }

                '[{0}]' -f $t
            }

            $m = [pscustomobject]@{
                Name         = $name
                PropertyName = $propertyName
                Type         = $propertyType
                IsListType   = $isListType
            }
            $typeWidth = $m.Type.Length + 1
            if ($typeWidth -gt $typeColumnWidth) {
                $typeColumnWidth = $typeWidth
            }

            $m
        }
    }

    $config = @{
        ClassName      = $className
        ClassMembers   = $ClassMembers
        ClassType      = $ClassType
        TypeColumWidth = $typeColumnWidth
    }
    if ($ClassType -in @('Request', 'Response')) {
        $config['Operation'] = $Entity
    }

    [pscustomobject]$config
}

function GenerateModel ([Parameter(Mandatory = $true)][object] $Configuration, [int] $Indentation = 4) {
    $requestClassName = $Configuration.ClassName
    $typeColumnWidth = $Configuration.TypeColumWidth
    $tab = ' ' * $Indentation

    $baseClase = switch ($Configuration.ClassType) {
        Request { ' : AmazonStorageGatewayRequest' }
        Response { ' : AmazonWebServiceResponse' }
        #### TODO: OTHERS
    }

    $modelOutput = New-Object System.Text.StringBuilder
    $modelPropertiesOutput = New-Object System.Text.StringBuilder
    $modelMethodsOutput = New-Object System.Text.StringBuilder

    foreach ($property in $Configuration.ClassMembers) {
        $line = '{0}{1}{2}' -f $tab, $property.Type.PadRight($typeColumnWidth, ' '), $property.PropertyName
        if ($property.IsListType) {
            $line += ' = {0}::new()' -f $property.Type
        }
        [void]$modelPropertiesOutput.AppendLine($line)

        [void]$modelMethodsOutput.AppendLine()
        $line = '{0}hidden [bool] IsSet{1}() {{' -f $tab, $property.Name
        [void]$modelMethodsOutput.AppendLine($line)
        $line = if ($property.IsListType) {
            '{0}{0}return ($this.{1} -and $this.{1}.Count -gt 0)' -f $tab, $property.Name
        } else {
            '{0}{0}return $this.{1} -ne $null' -f $tab, $property.Name
        }
        [void]$modelMethodsOutput.AppendLine($line)
        $line = '{0}}}' -f $tab
        [void]$modelMethodsOutput.AppendLine($line)
    }

    [void]$modelOutput.AppendLine(('class {0}{1} {{' -f $requestClassName, $baseClase))
    [void]$modelOutput.Append($modelPropertiesOutput.ToString())
    [void]$modelOutput.Append($modelMethodsOutput.ToString())
    [void]$modelOutput.AppendLine('}')
    [void]$modelOutput.AppendLine()

    $modelOutput.ToString().Trim()
}

function GenerateRequestMarshaller {
    param (
        [Parameter(Mandatory = $true)]
        [object] $Configuration,

        [Parameter(Mandatory = $true)]
        [string] $TemplatesDirectory,

        [int] $Indentation = 4
    )

    $templateName = 'AmazonWebServiceRequestMarshaller.template'
    $templatePath = Join-Path $TemplatesDirectory $templateName
    $template = [System.IO.File]::ReadAllText($templatePath)

    $operation = $Configuration.Operation
    $tab = ' ' * $Indentation

    $propertiesOutput = New-Object System.Text.StringBuilder
    foreach ($property in $Configuration.ClassMembers) {
        [void]$propertiesOutput.AppendLine()
        $line = '{0}{0}{0}if ($PublicRequest.IsSet{1}()) {{' -f $tab, $property.Name
        [void]$propertiesOutput.AppendLine($line)
        $line = '{0}{0}{0}{0}$context.Writer.WritePropertyName(''{1}'')' -f $tab, $property.Name
        [void]$propertiesOutput.AppendLine($line)

        if ($property.IsListType) {
            $line = '{0}{0}{0}{0}$context.Writer.WriteArrayStart()' -f $tab
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}foreach ($i in $PublicRequest.{1}) {{' -f $tab, $property.Name
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}{0}$context.Writer.Write($i)' -f $tab
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}}}' -f $tab
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}$context.Writer.WriteArrayEnd()' -f $tab
            [void]$propertiesOutput.AppendLine($line)
        } else {
            $line = '{0}{0}{0}{0}$context.Writer.Write($PublicRequest.{1})' -f $tab, $property.Name
            [void]$propertiesOutput.AppendLine($line)
        }

        $line = '{0}{0}{0}}}' -f $tab
        [void]$propertiesOutput.AppendLine($line)
    }

    $renderedTemplate = $template -replace '{{PROPERTIES}}', $propertiesOutput.ToString().Trim()

    ($renderedTemplate -replace '{{OPERATION}}', $operation).Trim()
}

function GenerateUnmarshaller {
    param (
        [Parameter(Mandatory = $true)]
        [object] $Configuration,

        [Parameter(Mandatory = $true)]
        [string] $TemplatesDirectory,

        [int] $Indentation = 4
    )

    $templateName = 'AmazonWebServiceResponseUnmarshaller.template'
    $templatePath = Join-Path $TemplatesDirectory $templateName
    $template = [System.IO.File]::ReadAllText($templatePath)

    $operation = '{0}Response' -f $Configuration.Operation
    $tab = ' ' * $Indentation

    $propertiesOutput = New-Object System.Text.StringBuilder
    foreach ($property in $Configuration.ClassMembers) {
        [void]$propertiesOutput.AppendLine()
        $line = '{0}{0}{0}if ($Context.TestExpression(''{1}'', $targetDepth)) {{' -f $tab, $property.Name
        [void]$propertiesOutput.AppendLine($line)

        if ($property.IsListType) {
            $listType = $property.Type -replace 'List|\[|\]'
            $line = (
                '{0}{0}{0}{0}[ListUnmarshaller[[{1}], [{1}Unmarshaller]]]$listUnmarshaller = ' +
                '[ListUnmarshaller[[{1}], [{1}Unmarshaller]]]::new([{1}Unmarshaller]::GetInstance())'
            ) -f $tab, $listType
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}$response.{1} = $listUnmarshaller.Unmarshall($Context)' -f $tab, $property.Name
            [void]$propertiesOutput.AppendLine($line)
        } else {
            $type = $property.Type -replace '\[|\]'
            $line = '{0}{0}{0}{0}$unmarshaller = [{1}Unmarshaller]::Instance' -f @(
                $tab,
                (Get-Culture).TextInfo.ToTitleCase($type)
            )
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}$response.{1} = $unmarshaller.Unmarshall($Context)' -f $tab, $property.Name
            [void]$propertiesOutput.AppendLine($line)
        }
        $line = '{0}{0}{0}{0}continue' -f $tab
        [void]$propertiesOutput.AppendLine($line)
        $line = '{0}{0}{0}}}' -f $tab
        [void]$propertiesOutput.AppendLine($line)
    }

    $renderedTemplate = $template -replace '{{PROPERTIES}}', $propertiesOutput.ToString().Trim()

    ($renderedTemplate -replace '{{OPERATION}}', $operation).Trim()
}

function GenerateGenericUnmarshaller {
    param (
        [Parameter(Mandatory = $true)]
        [object] $Configuration,

        [Parameter(Mandatory = $true)]
        [string] $TemplatesDirectory,

        [int] $Indentation = 4
    )

    $templateName = 'IUnmarshaller.template'
    $templatePath = Join-Path $TemplatesDirectory $templateName
    $template = [System.IO.File]::ReadAllText($templatePath)

    $operation = $Configuration.ClassName
    $tab = ' ' * $Indentation

    $propertiesOutput = New-Object System.Text.StringBuilder
    foreach ($property in $Configuration.ClassMembers) {
        [void]$propertiesOutput.AppendLine()
        $line = '{0}{0}{0}if ($Context.TestExpression(''{1}'', $targetDepth)) {{' -f $tab, $property.Name
        [void]$propertiesOutput.AppendLine($line)

        if ($property.IsListType) {
            $listType = $property.Type -replace 'List|\[|\]'
            if ($listType -eq 'string') {
                #### capitalize type name
                $line = (
                    '{0}{0}{0}{0}[ListUnmarshaller[[{1}], [StringUnmarshaller]]]$listUnmarshaller = ' +
                    '[ListUnmarshaller[[{1}], [StringUnmarshaller]]]::new([StringUnmarshaller]::Instance)'
                ) -f $tab, $listType
            } else {
                $line = (
                    '{0}{0}{0}{0}[ListUnmarshaller[[{1}], [{1}Unmarshaller]]]$listUnmarshaller = ' +
                    '[ListUnmarshaller[[{1}], [{1}Unmarshaller]]]::new([{1}Unmarshaller]::GetInstance())'
                ) -f $tab, $listType
            }
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}$response.{1} = $listUnmarshaller.Unmarshall($Context)' -f $tab, $property.Name
            [void]$propertiesOutput.AppendLine($line)
        } else {
            $type = (Get-Culture).TextInfo.ToTitleCase($property.Type -replace '\[|\]')
            $line ='{0}{0}{0}{0}$unmarshaller = [{1}Unmarshaller]::Instance' -f $tab, $type
            [void]$propertiesOutput.AppendLine($line)
            $line = '{0}{0}{0}{0}$response.{1} = $unmarshaller.Unmarshall($Context)' -f $tab, $property.Name
            [void]$propertiesOutput.AppendLine($line)
        }
        $line = '{0}{0}{0}{0}continue' -f $tab
        [void]$propertiesOutput.AppendLine($line)
        $line = '{0}{0}{0}}}' -f $tab
        [void]$propertiesOutput.AppendLine($line)
    }

    $renderedTemplate = $template -replace '{{PROPERTIES}}', $propertiesOutput.ToString().Trim()

    ($renderedTemplate -replace '{{CLASSNAME}}', $operation).Trim()
}

function GenerateServiceClient {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $ServiceClientConfig,

        [Parameter(Mandatory = $true)]
        [string] $TemplatesDirectory,

        [int] $Indentation = 4
    )

    $templateName = '{0}.template' -f $ServiceClientConfig['ServiceClassName']
    $templatePath = Join-Path $TemplatesDirectory $templateName
    $template = [System.IO.File]::ReadAllText($templatePath)

    $tab = ' ' * $Indentation

    $methodsOutput = New-Object System.Text.StringBuilder
    $genericMethodsOutput = New-Object System.Text.StringBuilder
    foreach ($operation in $ServiceClientConfig['ServiceClassOperations']) {
        $genericMethodName = '_{0}{1}' -f $operation.Substring(0, 1).ToLower(), $operation.Substring(1)
        $line = '{0}hidden [MethodInfo] ${1}' -f $tab, $genericMethodName
        [void]$genericMethodsOutput.AppendLine($line)

        [void]$methodsOutput.AppendLine()
        $line = '{0}[{1}Response] {1}([{1}Request] $Request) {{' -f $tab, $operation
        [void]$methodsOutput.AppendLine($line)

        $line = '{0}{0}if (-not $this.{1}) {{' -f $tab, $genericMethodName
        [void]$methodsOutput.AppendLine($line)
        $line = '{0}{0}{0}$this.{1} = $this._initMethod(@([{2}Request], [{2}Response]))' -f @(
            $tab,
            $genericMethodName,
            $operation
        )
        [void]$methodsOutput.AppendLine($line)
        $line = '{0}{0}}}' -f $tab
        [void]$methodsOutput.AppendLine($line)
        [void]$methodsOutput.AppendLine()

        $line = '{0}{0}$marshaller = [{1}RequestMarshaller]::GetInstance()' -f $tab, $operation
        [void]$methodsOutput.AppendLine($line)
        $line = '{0}{0}$unmarshaller = [{1}ResponseUnmarshaller]::GetInstance()' -f $tab, $operation
        [void]$methodsOutput.AppendLine($line)
        [void]$methodsOutput.AppendLine()
        $line = '{0}{0}return $this.{1}.Invoke($this, @($Request, $marshaller, $unmarshaller))' -f $tab, $genericMethodName
        [void]$methodsOutput.AppendLine($line)
        $line = '{0}}}' -f $tab
        [void]$methodsOutput.AppendLine($line)
    }

    $template.Replace(
        '{{METHODS}}', $methodsOutput.ToString().Trim()
    ).Replace(
        '{{GENERICMETHODS}}', $genericMethodsOutput.ToString().Trim()
    ).Trim()
}