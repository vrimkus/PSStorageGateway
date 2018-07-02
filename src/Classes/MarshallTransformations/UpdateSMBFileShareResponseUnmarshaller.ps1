class UpdateSMBFileShareResponseUnmarshaller : AmazonWebServiceResponseUnmarshaller {
    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        $response = [UpdateSMBFileShareResponse]::new()
        [void]$Context.Read()
        $targetDepth = $Context.CurrentDepth
        while ($Context.ReadAtDepth($targetDepth)) {
            if ($Context.TestExpression('FileShareARN', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.FileShareARN = $unmarshaller.Unmarshall($Context)
                continue
            }
        }

        return $response
    }

    hidden static [UpdateSMBFileShareResponseUnmarshaller] $_instance = [UpdateSMBFileShareResponseUnmarshaller]::new()

    static [UpdateSMBFileShareResponseUnmarshaller] GetInstance() {
        return [UpdateSMBFileShareResponseUnmarshaller]::_instance
    }
}