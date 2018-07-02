function SafeResolvePath ([string] $Path) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
}

$ModuleName = 'PSStorageGateway'

$SrcPath = SafeResolvePath -Path $PSScriptRoot/../src
$ManifestPath = SafeResolvePath -Path $SrcPath/$($ModuleName).psd1
$ModulePath = SafeResolvePath -Path $SrcPath/$($ModuleName).psm1
$DataTypesPath = SafeResolvePath -Path $SrcPath/Classes/DataTypes
$ModelsPath = SafeResolvePath -Path $SrcPath/Classes/Models
$TransformsPath = SafeResolvePath -Path $SrcPath/Classes/MarshallTransformations
$ClientsPath = SafeResolvePath -Path $SrcPath/Classes/Clients
$TemplatesPath = SafeResolvePath -Path $SrcPath/Classes/Templates

$ServiceClassConfig = Import-PowerShellDataFile -Path $PSScriptRoot/ServiceClientManifest.psd1
$Manifest = Import-PowerShellDataFile -Path $ManifestPath

$OutputPath = SafeResolvePath -Path $PSScriptRoot/../$ModuleName/$($Manifest.ModuleVersion)
$OutManifest = SafeResolvePath -Path $OutputPath/$($ModuleName).psd1
$OutModule = SafeResolvePath -Path $OutputPath/$($ModuleName).psm1

