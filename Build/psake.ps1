properties {
    . $PSScriptRoot/psake.properties.ps1
}

Include './build.Helpers.ps1'

task default -depends Build

task CleanDataTypes {
    Remove-Item -Path "$($DataTypesPath)/*.ps1" -Force
}

task CleanModels {
    Remove-Item -Path "$($ModelsPath)/*.ps1" -Force
}

task CleanMarshallTransformations {
    Remove-Item -Path "$($TransformsPath)/*.ps1" -Force
}

task CleanServiceClient {
    Remove-Item -Path "$($ClientsPath)/*.ps1" -Force
}

task Clean -depends CleanDataTypes, CleanModels, CleanMarshallTransformations {
    if (Test-Path -LiteralPath $OutputPath) {
        Remove-Item -Path $OutputPath -Recurse -Force
    }
}

task FetchServiceClassDataTypeConfigs {
    #### normally psake properties (set at top of file), are passed ByVal,
    #### and the $Script: scope modifier is necessary to update the global properties.
    #### This is not the case with [hashtable] objects.
    #### In PowerShell [hashtable] objects are always passed ByRef,
    #### so updated to the $ServiceClassConfig object are seen by all subsequent tasks.
    $ServiceClassConfig['GeneratedDataTypeConfigs'] = @()
    foreach ($entity in $ServiceClassConfig['ServiceClassDataTypes']) {
        $ServiceClassConfig['GeneratedDataTypeConfigs'] += BuildClassConfiguration -Entity $entity -ClassType DataType
    }
}

task FetchServiceClassModelConfigs {
    $ServiceClassConfig['GeneratedRequestModelConfigs'] = @()
    $ServiceClassConfig['GeneratedResponseModelConfigs'] = @()
    foreach ($entity in $ServiceClassConfig['ServiceClassOperations']) {
        $params = @{
            Entity = $entity
        }
        $ServiceClassConfig['GeneratedRequestModelConfigs'] += BuildClassConfiguration @params -ClassType Request
        $ServiceClassConfig['GeneratedResponseModelConfigs'] += BuildClassConfiguration @params -ClassType Response
    }
}

task BuildDataTypes -depends CleanDataTypes, FetchServiceClassDataTypeConfigs {
    $ServiceClassConfig['GeneratedDataTypeConfigs'] | ForEach {
        Write-Verbose "Building DataType [$($_.ClassName)]"
        $datatypeModelPath = "$($DataTypesPath)/$($_.ClassName).ps1"
        $datatypeModel = GenerateModel -Configuration $_
        [System.IO.File]::WriteAllText($datatypeModelPath, $datatypeModel, [System.Text.Encoding]::UTF8)
    }
}

task BuildModels -depends CleanModels, FetchServiceClassModelConfigs {
    @($ServiceClassConfig['GeneratedRequestModelConfigs'] + $ServiceClassConfig['GeneratedResponseModelConfigs']) |
        ForEach {
        Write-Verbose "Building Models [$($_.ClassName)]"
        $modelPath = "$($ModelsPath)/$($_.ClassName).ps1"
        $model = GenerateModel -Configuration $_
        [System.IO.File]::WriteAllText($modelPath, $model, [System.Text.Encoding]::UTF8)
    }
}

task BuildMarshallTransformations -depends CleanMarshallTransformations {
    $ServiceClassConfig['GeneratedRequestModelConfigs'] | ForEach {
        Write-Verbose "Building Marshaller [$($_.ClassName)Marshaller]"
        $marshallerPath = "$($TransformsPath)/$($_.ClassName)Marshaller.ps1"
        $marshaller = GenerateRequestMarshaller -Configuration $_ -TemplatesDirectory $templatesPath
        [System.IO.File]::WriteAllText($marshallerPath, $marshaller, [System.Text.Encoding]::UTF8)
    }

    $ServiceClassConfig['GeneratedResponseModelConfigs'] | ForEach {
        Write-Verbose "Building Unmarshaller [$($_.ClassName)Unmarshaller]"
        $unmarshallerPath = "$($TransformsPath)/$($_.ClassName)Unmarshaller.ps1"
        $unmarshaller = GenerateUnmarshaller -Configuration $_ -TemplatesDirectory $templatesPath
        [System.IO.File]::WriteAllText($unmarshallerPath, $unmarshaller, [System.Text.Encoding]::UTF8)
    }

    $ServiceClassConfig['GeneratedDataTypeConfigs'] | ForEach {
        Write-Verbose "Building Unmarshaller [$($_.ClassName)Unmarshaller]"
        $unmarshallerPath = "$($TransformsPath)/$($_.ClassName)Unmarshaller.ps1"
        $unmarshaller = GenerateGenericUnmarshaller -Configuration $_ -TemplatesDirectory $templatesPath
        [System.IO.File]::WriteAllText($unmarshallerPath, $unmarshaller, [System.Text.Encoding]::UTF8)
    }
}

task BuildServiceClient -depends CleanServiceClient {
    Write-Verbose "Building ServiceClient [$($ServiceClassConfig['ServiceClassName'])]"
    $serviceClientPath = "$($ClientsPath)/$($ServiceClassConfig['ServiceClassName']).ps1"
    $serviceClient = GenerateServiceClient -ServiceClientConfig $ServiceClassConfig -TemplatesDirectory $templatesPath
    [System.IO.File]::WriteAllText($serviceClientPath, $serviceClient, [System.Text.Encoding]::UTF8)
}

task Build -depends Clean, BuildDataTypes, BuildModels, BuildMarshallTransformations, BuildServiceClient {
    Write-Verbose "Creating module version [$($Manifest.ModuleVersion)]"
    [void](New-Item -Path $OutputPath -ItemType Directory)

    $params = @{
        Path     = $OutModule
        Encoding = [Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]::UTF8
    }

    #### Initialize Module
    Copy-Item -Path $ManifestPath -Destination $OutManifest
    Copy-Item -Path $modulePath -Destination $OutModule

    #### ServiceClient
    Add-Content -Value '' @params
    Get-ChildItem -Path $ClientsPath\*.ps1 | ForEach {
        Write-Verbose "Compiling [$($_.BaseName)]"
        Get-Content -Path $_.FullName | Add-Content @params
    }

    #### DataTypes
    Add-Content -Value '' @params
    Add-Content -Value '#region DataTypes' @params
    Get-ChildItem -Path $DataTypesPath\*.ps1 | ForEach {
        Write-Verbose "Compiling [$($_.BaseName)]"
        Add-Content -Value '' @params
        Get-Content -Path $_.FullName | Add-Content @params
    }
    Add-Content -Value '' @params
    Add-Content -Value '#endregion DataTypes' @params

    #### Models
    Add-Content -Value '' @params
    Add-Content -Value '#region Models' @params
    Get-ChildItem -Path $ModelsPath\*.ps1 | ForEach {
        Write-Verbose "Compiling [$($_.BaseName)]"
        Add-Content -Value '' @params
        Get-Content -Path $_.FullName | Add-Content @params
    }
    Add-Content -Value '' @params
    Add-Content -Value '#endregion Models' @params


    #### MarshallTransformations
    Add-Content -Value '' @params
    Add-Content -Value '#region MarshallTransformations' @params
    Get-ChildItem -Path $TransformsPath\*.ps1 | ForEach {
        Write-Verbose "Compiling [$($_.BaseName)]"
        Add-Content -Value '' @params
        Get-Content -Path $_.FullName | Add-Content @params
    }
    Add-Content -Value '' @params
    Add-Content -Value '#endregion MarshallTransformations' @params
}

