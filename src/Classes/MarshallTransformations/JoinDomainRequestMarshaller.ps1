class JoinDomainRequestMarshaller : AmazonWebServiceRequestMarshaller, IMarshaller`2[[IRequest], [JoinDomainRequest]] {
    [IRequest] Marshall([JoinDomainRequest] $PublicRequest) {
        [IRequest] $request = [DefaultRequest]::new($PublicRequest, 'Amazon.StorageGateway')
        $target = 'StorageGateway_20130630.JoinDomain'
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

            if ($PublicRequest.IsSetDomainName()) {
                $context.Writer.WritePropertyName('DomainName')
                $context.Writer.Write($PublicRequest.DomainName)
            }

            if ($PublicRequest.IsSetGatewayARN()) {
                $context.Writer.WritePropertyName('GatewayARN')
                $context.Writer.Write($PublicRequest.GatewayARN)
            }

            if ($PublicRequest.IsSetPassword()) {
                $context.Writer.WritePropertyName('Password')
                $context.Writer.Write($PublicRequest.Password)
            }

            if ($PublicRequest.IsSetUserName()) {
                $context.Writer.WritePropertyName('UserName')
                $context.Writer.Write($PublicRequest.UserName)
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

    hidden static [JoinDomainRequestMarshaller] $_instance = [JoinDomainRequestMarshaller]::new()

    static [JoinDomainRequestMarshaller] GetInstance() {
        return [JoinDomainRequestMarshaller]::_instance
    }
}