class DescribeSMBFileSharesResponseUnmarshaller : AmazonWebServiceResponseUnmarshaller {
    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        $response = [DescribeSMBFileSharesResponse]::new()
        [void]$Context.Read()
        $targetDepth = $Context.CurrentDepth
        while ($Context.ReadAtDepth($targetDepth)) {
            if ($Context.TestExpression('SMBFileShareInfoList', $targetDepth)) {
                [ListUnmarshaller[[SMBFileShareInfo], [SMBFileShareInfoUnmarshaller]]]$listUnmarshaller = [ListUnmarshaller[[SMBFileShareInfo], [SMBFileShareInfoUnmarshaller]]]::new([SMBFileShareInfoUnmarshaller]::GetInstance())
                $response.SMBFileShareInfoList = $listUnmarshaller.Unmarshall($Context)
                continue
            }
        }

        return $response
    }

    hidden static [DescribeSMBFileSharesResponseUnmarshaller] $_instance = [DescribeSMBFileSharesResponseUnmarshaller]::new()

    static [DescribeSMBFileSharesResponseUnmarshaller] GetInstance() {
        return [DescribeSMBFileSharesResponseUnmarshaller]::_instance
    }
}