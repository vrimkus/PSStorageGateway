class JoinDomainResponse : AmazonWebServiceResponse {
    [string] $GatewayARN

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }
}