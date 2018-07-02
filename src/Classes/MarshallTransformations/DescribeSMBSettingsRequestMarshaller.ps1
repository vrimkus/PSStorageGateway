class DescribeSMBSettingsRequestMarshaller : AmazonWebServiceRequestMarshaller, IMarshaller`2[[IRequest], [DescribeSMBSettingsRequest]] {
    [IRequest] Marshall([DescribeSMBSettingsRequest] $PublicRequest) {
        [IRequest] $request = [DefaultRequest]::new($PublicRequest, 'Amazon.StorageGateway')
        $target = 'StorageGateway_20130630.DescribeSMBSettings'
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

            if ($PublicRequest.IsSetGatewayARN()) {
                $context.Writer.WritePropertyName('GatewayARN')
                $context.Writer.Write($PublicRequest.GatewayARN)
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

    hidden static [DescribeSMBSettingsRequestMarshaller] $_instance = [DescribeSMBSettingsRequestMarshaller]::new()

    static [DescribeSMBSettingsRequestMarshaller] GetInstance() {
        return [DescribeSMBSettingsRequestMarshaller]::_instance
    }
}