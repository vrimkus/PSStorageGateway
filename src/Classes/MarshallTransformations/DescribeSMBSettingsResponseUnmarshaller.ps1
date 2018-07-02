class DescribeSMBSettingsResponseUnmarshaller : AmazonWebServiceResponseUnmarshaller {
    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        $response = [DescribeSMBSettingsResponse]::new()
        [void]$Context.Read()
        $targetDepth = $Context.CurrentDepth
        while ($Context.ReadAtDepth($targetDepth)) {
            if ($Context.TestExpression('DomainName', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.DomainName = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('GatewayARN', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.GatewayARN = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('SMBGuestPasswordSet', $targetDepth)) {
                $unmarshaller = [BoolUnmarshaller]::Instance
                $response.SMBGuestPasswordSet = $unmarshaller.Unmarshall($Context)
                continue
            }
        }

        return $response
    }

    hidden static [DescribeSMBSettingsResponseUnmarshaller] $_instance = [DescribeSMBSettingsResponseUnmarshaller]::new()

    static [DescribeSMBSettingsResponseUnmarshaller] GetInstance() {
        return [DescribeSMBSettingsResponseUnmarshaller]::_instance
    }
}