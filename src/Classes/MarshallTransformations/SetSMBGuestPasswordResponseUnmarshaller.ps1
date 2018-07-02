class SetSMBGuestPasswordResponseUnmarshaller : AmazonWebServiceResponseUnmarshaller {
    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        $response = [SetSMBGuestPasswordResponse]::new()
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

    hidden static [SetSMBGuestPasswordResponseUnmarshaller] $_instance = [SetSMBGuestPasswordResponseUnmarshaller]::new()

    static [SetSMBGuestPasswordResponseUnmarshaller] GetInstance() {
        return [SetSMBGuestPasswordResponseUnmarshaller]::_instance
    }
}