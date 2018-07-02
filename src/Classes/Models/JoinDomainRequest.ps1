class JoinDomainRequest : AmazonStorageGatewayRequest {
    [string] $DomainName
    [string] $GatewayARN
    [string] $Password
    [string] $UserName

    hidden [bool] IsSetDomainName() {
        return $this.DomainName -ne $null
    }

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetPassword() {
        return $this.Password -ne $null
    }

    hidden [bool] IsSetUserName() {
        return $this.UserName -ne $null
    }
}