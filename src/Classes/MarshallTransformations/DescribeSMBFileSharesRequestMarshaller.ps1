class DescribeSMBFileSharesRequestMarshaller : AmazonWebServiceRequestMarshaller, IMarshaller`2[[IRequest], [DescribeSMBFileSharesRequest]] {
    [IRequest] Marshall([DescribeSMBFileSharesRequest] $PublicRequest) {
        [IRequest] $request = [DefaultRequest]::new($PublicRequest, 'Amazon.StorageGateway')
        $target = 'StorageGateway_20130630.DescribeSMBFileShares'
        $request.Headers['X-Amz-Target'] = $target
        $request.Headers['Content-Type'] = 'application/x-amz-json-1.1'
        $request.HttpMethod = 'POST'

        $uriResourcePath = '/'
        $request.ResourcePath = $uriResourcePath

        [StringWriter] $stringWriter = $null
        try {
            $stringWriter = [StringWriter]::new([CultureInfo]::InvariantCulture)
            $writer = [JsonWriter]::new($stringWriter)
            $writer.WriteObjectStart()
            $context = [JsonMarshallerContext]::new($request, $writer)

            if ($PublicRequest.IsSetFileShareARNList()) {
                $context.Writer.WritePropertyName('FileShareARNList')
                $context.Writer.WriteArrayStart()
                foreach ($i in $PublicRequest.FileShareARNList) {
                    $context.Writer.Write($i)
                }
                $context.Writer.WriteArrayEnd()
            }

            $writer.WriteObjectEnd()
            $snippet = $stringWriter.ToString()
            $request.Content = [System.Text.Encoding]::UTF8.GetBytes($snippet)
        } finally {
            if ($stringWriter -is [StringWriter]) {
                $stringWriter.Dispose()
            }
        }

        return $request
    }

    hidden static [DescribeSMBFileSharesRequestMarshaller] $_instance = [DescribeSMBFileSharesRequestMarshaller]::new()

    static [DescribeSMBFileSharesRequestMarshaller] GetInstance() {
        return [DescribeSMBFileSharesRequestMarshaller]::_instance
    }
}