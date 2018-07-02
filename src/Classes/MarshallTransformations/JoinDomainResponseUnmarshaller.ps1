class JoinDomainResponseUnmarshaller : AmazonWebServiceResponseUnmarshaller {
    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        $response = [JoinDomainResponse]::new()
        [void]$Context.Read()
        $targetDepth = $Context.CurrentDepth
        while ($Context.ReadAtDepth($targetDepth)) {
            if ($Context.TestExpression('GatewayARN', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.GatewayARN = $unmarshaller.Unmarshall($Context)
                continue
            }
        }

        return $response
    }

    hidden static [JoinDomainResponseUnmarshaller] $_instance = [JoinDomainResponseUnmarshaller]::new()

    static [JoinDomainResponseUnmarshaller] GetInstance() {
        return [JoinDomainResponseUnmarshaller]::_instance
    }
}