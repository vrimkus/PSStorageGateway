@{
    ServiceClassName       = 'PSStorageGatewayClient'
    ServiceClassDataTypes  = @('SMBFileShareInfo')
    ServiceClassOperations = @(
        'JoinDomain',
        'CreateSMBFileShare',
        'DescribeSMBFileShares',
        'DescribeSMBSettings',
        'SetSMBGuestPassword',
        'UpdateSMBFileShare'
    )
}