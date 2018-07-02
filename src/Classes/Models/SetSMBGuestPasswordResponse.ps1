class SetSMBGuestPasswordResponse : AmazonWebServiceResponse {
    [string] $GatewayARN

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }
}