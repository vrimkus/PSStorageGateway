class DescribeSMBSettingsRequest : AmazonStorageGatewayRequest {
    [string] $GatewayARN

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }
}