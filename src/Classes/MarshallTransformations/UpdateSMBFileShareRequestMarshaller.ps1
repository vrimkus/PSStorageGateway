class UpdateSMBFileShareRequestMarshaller : AmazonWebServiceRequestMarshaller, IMarshaller`2[[IRequest], [UpdateSMBFileShareRequest]] {
    [IRequest] Marshall([UpdateSMBFileShareRequest] $PublicRequest) {
        [IRequest] $request = [DefaultRequest]::new($PublicRequest, 'Amazon.StorageGateway')
        $target = 'StorageGateway_20130630.UpdateSMBFileShare'
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

            if ($PublicRequest.IsSetDefaultStorageClass()) {
                $context.Writer.WritePropertyName('DefaultStorageClass')
                $context.Writer.Write($PublicRequest.DefaultStorageClass)
            }

            if ($PublicRequest.IsSetFileShareARN()) {
                $context.Writer.WritePropertyName('FileShareARN')
                $context.Writer.Write($PublicRequest.FileShareARN)
            }

            if ($PublicRequest.IsSetGuessMIMETypeEnabled()) {
                $context.Writer.WritePropertyName('GuessMIMETypeEnabled')
                $context.Writer.Write($PublicRequest.GuessMIMETypeEnabled)
            }

            if ($PublicRequest.IsSetInvalidUserList()) {
                $context.Writer.WritePropertyName('InvalidUserList')
                $context.Writer.WriteArrayStart()
                foreach ($i in $PublicRequest.InvalidUserList) {
                    $context.Writer.Write($i)
                }
                $context.Writer.WriteArrayEnd()
            }

            if ($PublicRequest.IsSetKMSEncrypted()) {
                $context.Writer.WritePropertyName('KMSEncrypted')
                $context.Writer.Write($PublicRequest.KMSEncrypted)
            }

            if ($PublicRequest.IsSetKMSKey()) {
                $context.Writer.WritePropertyName('KMSKey')
                $context.Writer.Write($PublicRequest.KMSKey)
            }

            if ($PublicRequest.IsSetObjectACL()) {
                $context.Writer.WritePropertyName('ObjectACL')
                $context.Writer.Write($PublicRequest.ObjectACL)
            }

            if ($PublicRequest.IsSetReadOnly()) {
                $context.Writer.WritePropertyName('ReadOnly')
                $context.Writer.Write($PublicRequest.ReadOnly)
            }

            if ($PublicRequest.IsSetRequesterPays()) {
                $context.Writer.WritePropertyName('RequesterPays')
                $context.Writer.Write($PublicRequest.RequesterPays)
            }

            if ($PublicRequest.IsSetValidUserList()) {
                $context.Writer.WritePropertyName('ValidUserList')
                $context.Writer.WriteArrayStart()
                foreach ($i in $PublicRequest.ValidUserList) {
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

    hidden static [UpdateSMBFileShareRequestMarshaller] $_instance = [UpdateSMBFileShareRequestMarshaller]::new()

    static [UpdateSMBFileShareRequestMarshaller] GetInstance() {
        return [UpdateSMBFileShareRequestMarshaller]::_instance
    }
}