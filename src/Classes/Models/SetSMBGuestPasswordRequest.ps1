class SetSMBGuestPasswordRequest : AmazonStorageGatewayRequest {
    [string] $GatewayARN
    [string] $Password

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetPassword() {
        return $this.Password -ne $null
    }
}