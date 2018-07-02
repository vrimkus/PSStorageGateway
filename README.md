# PSStorageGateway

A PowerShell extension class implementation of AWSStorageGatwayClient SMB API operations.

Module is generated from AWS API Reference Documentation.

Highlights how PowerShell classes can be used to extend existing .NET classes (along with quirks encountered while experimenting).

# Usage
To import PowerShell Classes defined inside a PowerShell Module, you can use the `using module <Module>` statement.

```powershell
using Module .\PSStorageGateway

$client = [PSStorageGatewayClient]::new((Get-AWSCredential -ProfileName 'myawsprofile'), 'us-east-2')
$response = $client.DescribeSMBFileShares((New-Object DescribeSMBFileSharesRequest -Property @{
    FileShareARNList = @('arn:aws:storagegateway:us-east-2:204469490176:share/share-XXXXXX')
}))

#### Response
# $response.SMBFileShareInfoList

# Authentication       : ActiveDirectory
# DefaultStorageClass  : S3_STANDARD_IA
# FileShareARN         : arn:aws:storagegateway:us-east-2:111122223333:share/share-XXXXXXXX
# FileShareId          : share-XXXXXXXX
# FileShareStatus      : AVAILABLE
# GatewayARN           : arn:aws:storagegateway:us-east-2:111122223333:gateway/sgw-YYYYYYYY
# GuessMIMETypeEnabled : True
# InvalidUserList      : {user1, user2}
# KMSEncrypted         : False
# KMSKey               :
# LocationARN          : arn:aws:s3:::my-bucket
# ObjectACL            : bucket-owner-full-control
# Path                 : /my-path-alpha
# ReadOnly             : False
# RequesterPays        : False
# Role                 : arn:aws:iam::111122223333:role/my-role
# ValidUserList        : {user3, user4}

```

# Rebuild
To rebuild the module, use `build.ps1`, which will query the AWS API Reference for AWSStorageGatewayClient Operations/DataTypes to produce corresponding PowerShell Classes. The resulting classes are then compiled into a single `.psm1` file.

```powershell
.\build.ps1
```
