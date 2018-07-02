class DescribeSMBSettingsResponse : AmazonWebServiceResponse {
    [string] $DomainName
    [string] $GatewayARN
    [bool]   $SMBGuestPasswordSet

    hidden [bool] IsSetDomainName() {
        return $this.DomainName -ne $null
    }

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetSMBGuestPasswordSet() {
        return $this.SMBGuestPasswordSet -ne $null
    }
}