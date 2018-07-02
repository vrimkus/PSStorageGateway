class CreateSMBFileShareResponseUnmarshaller : AmazonWebServiceResponseUnmarshaller {
    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        $response = [CreateSMBFileShareResponse]::new()
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

    hidden static [CreateSMBFileShareResponseUnmarshaller] $_instance = [CreateSMBFileShareResponseUnmarshaller]::new()

    static [CreateSMBFileShareResponseUnmarshaller] GetInstance() {
        return [CreateSMBFileShareResponseUnmarshaller]::_instance
    }
}