#Requires -Module AWSPowerShell
#Requires -Version 5

using namespace System.Collections.Generic
using namespace System.Globalization
using namespace System.IO
using namespace System.Net
using namespace System.Reflection
using namespace Amazon
using namespace Amazon.StorageGateway
using namespace Amazon.StorageGateway.Model
using namespace Amazon.Runtime
using namespace Amazon.Runtime.Internal
using namespace Amazon.Runtime.Internal.Transform
using namespace Amazon.StorageGateway.Model.Internal.MarshallTransformations
using namespace ThirdParty.Json.LitJson

#region Service Client

class PSStorageGatewayClient : AmazonStorageGatewayClient {

    PSStorageGatewayClient([AWSCredentials] $Credentials, [string] $RegionName)
    : base($Credentials,
        (
            New-Object AmazonStorageGatewayConfig -Property @{
                RegionEndpoint = [RegionEndpoint]::GetBySystemName($RegionName)
            }
        )
    ) {}

    PSStorageGatewayClient([AWSCredentials] $Credentials, [RegionEndpoint] $Region)
    : base($Credentials,
        (
            New-Object AmazonStorageGatewayConfig -Property @{
                RegionEndpoint = $Region
            }
        )
    ) {}

    PSStorageGatewayClient([AWSCredentials] $Credentials, [AmazonStorageGatewayConfig] $ClientConfig)
    : base($Credentials, $ClientConfig) {}

    #### AmazonStorageGatewayClient SMB Operation Extension Methods
    [JoinDomainResponse] JoinDomain([JoinDomainRequest] $Request) {
        if (-not $this._joinDomain) {
            $this._joinDomain = $this._initMethod(@([JoinDomainRequest], [JoinDomainResponse]))
        }

        $marshaller = [JoinDomainRequestMarshaller]::GetInstance()
        $unmarshaller = [JoinDomainResponseUnmarshaller]::GetInstance()

        return $this._joinDomain.Invoke($this, @($Request, $marshaller, $unmarshaller))
    }

    [CreateSMBFileShareResponse] CreateSMBFileShare([CreateSMBFileShareRequest] $Request) {
        if (-not $this._createSMBFileShare) {
            $this._createSMBFileShare = $this._initMethod(@([CreateSMBFileShareRequest], [CreateSMBFileShareResponse]))
        }

        $marshaller = [CreateSMBFileShareRequestMarshaller]::GetInstance()
        $unmarshaller = [CreateSMBFileShareResponseUnmarshaller]::GetInstance()

        return $this._createSMBFileShare.Invoke($this, @($Request, $marshaller, $unmarshaller))
    }

    [DescribeSMBFileSharesResponse] DescribeSMBFileShares([DescribeSMBFileSharesRequest] $Request) {
        if (-not $this._describeSMBFileShares) {
            $this._describeSMBFileShares = $this._initMethod(@([DescribeSMBFileSharesRequest], [DescribeSMBFileSharesResponse]))
        }

        $marshaller = [DescribeSMBFileSharesRequestMarshaller]::GetInstance()
        $unmarshaller = [DescribeSMBFileSharesResponseUnmarshaller]::GetInstance()

        return $this._describeSMBFileShares.Invoke($this, @($Request, $marshaller, $unmarshaller))
    }

    [DescribeSMBSettingsResponse] DescribeSMBSettings([DescribeSMBSettingsRequest] $Request) {
        if (-not $this._describeSMBSettings) {
            $this._describeSMBSettings = $this._initMethod(@([DescribeSMBSettingsRequest], [DescribeSMBSettingsResponse]))
        }

        $marshaller = [DescribeSMBSettingsRequestMarshaller]::GetInstance()
        $unmarshaller = [DescribeSMBSettingsResponseUnmarshaller]::GetInstance()

        return $this._describeSMBSettings.Invoke($this, @($Request, $marshaller, $unmarshaller))
    }

    [SetSMBGuestPasswordResponse] SetSMBGuestPassword([SetSMBGuestPasswordRequest] $Request) {
        if (-not $this._setSMBGuestPassword) {
            $this._setSMBGuestPassword = $this._initMethod(@([SetSMBGuestPasswordRequest], [SetSMBGuestPasswordResponse]))
        }

        $marshaller = [SetSMBGuestPasswordRequestMarshaller]::GetInstance()
        $unmarshaller = [SetSMBGuestPasswordResponseUnmarshaller]::GetInstance()

        return $this._setSMBGuestPassword.Invoke($this, @($Request, $marshaller, $unmarshaller))
    }

    [UpdateSMBFileShareResponse] UpdateSMBFileShare([UpdateSMBFileShareRequest] $Request) {
        if (-not $this._updateSMBFileShare) {
            $this._updateSMBFileShare = $this._initMethod(@([UpdateSMBFileShareRequest], [UpdateSMBFileShareResponse]))
        }

        $marshaller = [UpdateSMBFileShareRequestMarshaller]::GetInstance()
        $unmarshaller = [UpdateSMBFileShareResponseUnmarshaller]::GetInstance()

        return $this._updateSMBFileShare.Invoke($this, @($Request, $marshaller, $unmarshaller))
    }

    hidden [MethodInfo] $_joinDomain
    hidden [MethodInfo] $_createSMBFileShare
    hidden [MethodInfo] $_describeSMBFileShares
    hidden [MethodInfo] $_describeSMBSettings
    hidden [MethodInfo] $_setSMBGuestPassword
    hidden [MethodInfo] $_updateSMBFileShare

    hidden [MethodInfo] _initMethod([type[]] $TypeParameters) {
        $invokeMethod = $this.GetType().GetMethod('Invoke', [BindingFlags]'NonPublic, Instance')

        return $invokeMethod.MakeGenericMethod($TypeParameters)
    }
}

#endregion Service Client

#region Abstract Helper Classes

#### PowerShell can only inherit multiple interfaces, if also inheriting from a base class.
#### So We can create a base class, which inherits Interface [IMarshaller[[IRequest], [AmazonWebServiceRequest]]],
#### and provides pseudo-abstract class behavior. Then we can derive that in our marshaller classes,
#### while also inheriting the additional Interface, [IMarshaller[[IRequest], [<REQUEST_MODEL>]]].
class AmazonWebServiceRequestMarshaller : IMarshaller`2[[IRequest], [AmazonWebServiceRequest]] {
    AmazonWebServiceRequestMarshaller() {
        $type = $this.GetType()
        if ($type -eq [AmazonWebServiceRequestMarshaller]) {
            throw [InvalidOperationException]::new("Abstract class [$($type)] must be inherited")
        }
    }

    [IRequest] Marshall([AmazonWebServiceRequest] $Input) {
        #### Get request object type from derived marshaller name
        $requestTypeName = $this.GetType().Name -replace 'Marshaller$'
        $type = $requestTypeName -as [type]
        if (-not $type) {
            throw "AmazonWebServiceRequestMarshaller exception. Details: Unable to locate type [$($requestTypeName)]"
        }
        $validatedInput = $Input -as $type
        if (-not $validatedInput) {
            throw (
                "AmazonWebServiceRequestMarshaller Marshalling Exception. " +
                "Details: Error while casting input, of type [$($Input.GetType())], to type [$($requestTypeName)]")
        }
        return $this.Marshall($validatedInput)
    }
}

class AmazonWebServiceResponseUnmarshaller : JsonResponseUnmarshaller {
    AmazonWebServiceResponseUnmarshaller() {
        $type = $this.GetType()
        if ($type -eq [AmazonWebServiceResponseUnmarshaller]) {
            throw [InvalidOperationException]::new("Abstract class [$($type)] must be inherited")
        }
    }

    [AmazonWebServiceResponse] Unmarshall([JsonUnmarshallerContext] $Context) {
        throw [NotImplementedException]::new()
    }

    [AmazonServiceException] UnmarshallException(
        [JsonUnmarshallerContext] $Context, [Exception] $InnerException, [HttpStatusCode] $StatusCode
    ) {
        $errorResponse = [JsonErrorResponseUnmarshaller]::GetInstance().Unmarshall($Context)
        if ($errorResponse.Code -and $errorResponse.Code -eq 'InternalServerError') {
            return [InternalServerErrorException]::new(
                $errorResponse.Message,
                $InnerException,
                $errorResponse.Type,
                $errorResponse.Code,
                $errorResponse.RequestId, $StatusCode)
        }

        if ($errorResponse.Code -and $errorResponse.Code -eq 'InvalidGatewayRequestException') {
            return [InvalidGatewayRequestException]::new(
                $errorResponse.Message,
                $InnerException,
                $errorResponse.Type,
                $errorResponse.Code,
                $errorResponse.RequestId, $StatusCode)
        }

        return [AmazonStorageGatewayException]::new(
            $errorResponse.Message,
            $InnerException,
            $errorResponse.Type,
            $errorResponse.Code,
            $errorResponse.RequestId, $StatusCode)
    }
}

#endregion Abstract Helper Classes

#region DataTypes

class SMBFileShareInfo {
    [string]       $Authentication
    [string]       $DefaultStorageClass
    [string]       $FileShareARN
    [string]       $FileShareId
    [string]       $FileShareStatus
    [string]       $GatewayARN
    [bool]         $GuessMIMETypeEnabled
    [List[string]] $InvalidUserList = [List[string]]::new()
    [bool]         $KMSEncrypted
    [string]       $KMSKey
    [string]       $LocationARN
    [string]       $ObjectACL
    [string]       $Path
    [bool]         $ReadOnly
    [bool]         $RequesterPays
    [string]       $Role
    [List[string]] $ValidUserList = [List[string]]::new()

    hidden [bool] IsSetAuthentication() {
        return $this.Authentication -ne $null
    }

    hidden [bool] IsSetDefaultStorageClass() {
        return $this.DefaultStorageClass -ne $null
    }

    hidden [bool] IsSetFileShareARN() {
        return $this.FileShareARN -ne $null
    }

    hidden [bool] IsSetFileShareId() {
        return $this.FileShareId -ne $null
    }

    hidden [bool] IsSetFileShareStatus() {
        return $this.FileShareStatus -ne $null
    }

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetGuessMIMETypeEnabled() {
        return $this.GuessMIMETypeEnabled -ne $null
    }

    hidden [bool] IsSetInvalidUserList() {
        return ($this.InvalidUserList -and $this.InvalidUserList.Count -gt 0)
    }

    hidden [bool] IsSetKMSEncrypted() {
        return $this.KMSEncrypted -ne $null
    }

    hidden [bool] IsSetKMSKey() {
        return $this.KMSKey -ne $null
    }

    hidden [bool] IsSetLocationARN() {
        return $this.LocationARN -ne $null
    }

    hidden [bool] IsSetObjectACL() {
        return $this.ObjectACL -ne $null
    }

    hidden [bool] IsSetPath() {
        return $this.Path -ne $null
    }

    hidden [bool] IsSetReadOnly() {
        return $this.ReadOnly -ne $null
    }

    hidden [bool] IsSetRequesterPays() {
        return $this.RequesterPays -ne $null
    }

    hidden [bool] IsSetRole() {
        return $this.Role -ne $null
    }

    hidden [bool] IsSetValidUserList() {
        return ($this.ValidUserList -and $this.ValidUserList.Count -gt 0)
    }
}

#endregion DataTypes

#region Models

class CreateSMBFileShareRequest : AmazonStorageGatewayRequest {
    [string]       $Authentication
    [string]       $ClientToken
    [string]       $DefaultStorageClass
    [string]       $GatewayARN
    [bool]         $GuessMIMETypeEnabled
    [List[string]] $InvalidUserList = [List[string]]::new()
    [bool]         $KMSEncrypted
    [string]       $KMSKey
    [string]       $LocationARN
    [string]       $ObjectACL
    [bool]         $ReadOnly
    [bool]         $RequesterPays
    [string]       $Role
    [List[string]] $ValidUserList = [List[string]]::new()

    hidden [bool] IsSetAuthentication() {
        return $this.Authentication -ne $null
    }

    hidden [bool] IsSetClientToken() {
        return $this.ClientToken -ne $null
    }

    hidden [bool] IsSetDefaultStorageClass() {
        return $this.DefaultStorageClass -ne $null
    }

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetGuessMIMETypeEnabled() {
        return $this.GuessMIMETypeEnabled -ne $null
    }

    hidden [bool] IsSetInvalidUserList() {
        return ($this.InvalidUserList -and $this.InvalidUserList.Count -gt 0)
    }

    hidden [bool] IsSetKMSEncrypted() {
        return $this.KMSEncrypted -ne $null
    }

    hidden [bool] IsSetKMSKey() {
        return $this.KMSKey -ne $null
    }

    hidden [bool] IsSetLocationARN() {
        return $this.LocationARN -ne $null
    }

    hidden [bool] IsSetObjectACL() {
        return $this.ObjectACL -ne $null
    }

    hidden [bool] IsSetReadOnly() {
        return $this.ReadOnly -ne $null
    }

    hidden [bool] IsSetRequesterPays() {
        return $this.RequesterPays -ne $null
    }

    hidden [bool] IsSetRole() {
        return $this.Role -ne $null
    }

    hidden [bool] IsSetValidUserList() {
        return ($this.ValidUserList -and $this.ValidUserList.Count -gt 0)
    }
}

class CreateSMBFileShareResponse : AmazonWebServiceResponse {
    [string] $FileShareARN

    hidden [bool] IsSetFileShareARN() {
        return $this.FileShareARN -ne $null
    }
}

class DescribeSMBFileSharesRequest : AmazonStorageGatewayRequest {
    [List[string]] $FileShareARNList = [List[string]]::new()

    hidden [bool] IsSetFileShareARNList() {
        return ($this.FileShareARNList -and $this.FileShareARNList.Count -gt 0)
    }
}

class DescribeSMBFileSharesResponse : AmazonWebServiceResponse {
    [List[SMBFileShareInfo]] $SMBFileShareInfoList = [List[SMBFileShareInfo]]::new()

    hidden [bool] IsSetSMBFileShareInfoList() {
        return ($this.SMBFileShareInfoList -and $this.SMBFileShareInfoList.Count -gt 0)
    }
}

class DescribeSMBSettingsRequest : AmazonStorageGatewayRequest {
    [string] $GatewayARN

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }
}

class DescribeSMBSettingsResponse : AmazonWebServiceResponse {
    [string] $DomainName
    [string] $GatewayARN
    [bool]   $SMBGuestPasswordSet

    hidden [bool] IsSetDomainName() {
        return $this.DomainName -ne $null
    }

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetSMBGuestPasswordSet() {
        return $this.SMBGuestPasswordSet -ne $null
    }
}

class JoinDomainRequest : AmazonStorageGatewayRequest {
    [string] $DomainName
    [string] $GatewayARN
    [string] $Password
    [string] $UserName

    hidden [bool] IsSetDomainName() {
        return $this.DomainName -ne $null
    }

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetPassword() {
        return $this.Password -ne $null
    }

    hidden [bool] IsSetUserName() {
        return $this.UserName -ne $null
    }
}

class JoinDomainResponse : AmazonWebServiceResponse {
    [string] $GatewayARN

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }
}

class SetSMBGuestPasswordRequest : AmazonStorageGatewayRequest {
    [string] $GatewayARN
    [string] $Password

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }

    hidden [bool] IsSetPassword() {
        return $this.Password -ne $null
    }
}

class SetSMBGuestPasswordResponse : AmazonWebServiceResponse {
    [string] $GatewayARN

    hidden [bool] IsSetGatewayARN() {
        return $this.GatewayARN -ne $null
    }
}

class UpdateSMBFileShareRequest : AmazonStorageGatewayRequest {
    [string]       $DefaultStorageClass
    [string]       $FileShareARN
    [bool]         $GuessMIMETypeEnabled
    [List[string]] $InvalidUserList = [List[string]]::new()
    [bool]         $KMSEncrypted
    [string]       $KMSKey
    [string]       $ObjectACL
    [bool]         $ReadOnly
    [bool]         $RequesterPays
    [List[string]] $ValidUserList = [List[string]]::new()

    hidden [bool] IsSetDefaultStorageClass() {
        return $this.DefaultStorageClass -ne $null
    }

    hidden [bool] IsSetFileShareARN() {
        return $this.FileShareARN -ne $null
    }

    hidden [bool] IsSetGuessMIMETypeEnabled() {
        return $this.GuessMIMETypeEnabled -ne $null
    }

    hidden [bool] IsSetInvalidUserList() {
        return ($this.InvalidUserList -and $this.InvalidUserList.Count -gt 0)
    }

    hidden [bool] IsSetKMSEncrypted() {
        return $this.KMSEncrypted -ne $null
    }

    hidden [bool] IsSetKMSKey() {
        return $this.KMSKey -ne $null
    }

    hidden [bool] IsSetObjectACL() {
        return $this.ObjectACL -ne $null
    }

    hidden [bool] IsSetReadOnly() {
        return $this.ReadOnly -ne $null
    }

    hidden [bool] IsSetRequesterPays() {
        return $this.RequesterPays -ne $null
    }

    hidden [bool] IsSetValidUserList() {
        return ($this.ValidUserList -and $this.ValidUserList.Count -gt 0)
    }
}

class UpdateSMBFileShareResponse : AmazonWebServiceResponse {
    [string] $FileShareARN

    hidden [bool] IsSetFileShareARN() {
        return $this.FileShareARN -ne $null
    }
}

#endregion Models

#region MarshallTransformations

class CreateSMBFileShareRequestMarshaller : AmazonWebServiceRequestMarshaller, IMarshaller`2[[IRequest], [CreateSMBFileShareRequest]] {
    [IRequest] Marshall([CreateSMBFileShareRequest] $PublicRequest) {
        [IRequest] $request = [DefaultRequest]::new($PublicRequest, 'Amazon.StorageGateway')
        $target = 'StorageGateway_20130630.CreateSMBFileShare'
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

            if ($PublicRequest.IsSetAuthentication()) {
                $context.Writer.WritePropertyName('Authentication')
                $context.Writer.Write($PublicRequest.Authentication)
            }

            if ($PublicRequest.IsSetClientToken()) {
                $context.Writer.WritePropertyName('ClientToken')
                $context.Writer.Write($PublicRequest.ClientToken)
            }

            if ($PublicRequest.IsSetDefaultStorageClass()) {
                $context.Writer.WritePropertyName('DefaultStorageClass')
                $context.Writer.Write($PublicRequest.DefaultStorageClass)
            }

            if ($PublicRequest.IsSetGatewayARN()) {
                $context.Writer.WritePropertyName('GatewayARN')
                $context.Writer.Write($PublicRequest.GatewayARN)
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

            if ($PublicRequest.IsSetLocationARN()) {
                $context.Writer.WritePropertyName('LocationARN')
                $context.Writer.Write($PublicRequest.LocationARN)
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

            if ($PublicRequest.IsSetRole()) {
                $context.Writer.WritePropertyName('Role')
                $context.Writer.Write($PublicRequest.Role)
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

    hidden static [CreateSMBFileShareRequestMarshaller] $_instance = [CreateSMBFileShareRequestMarshaller]::new()

    static [CreateSMBFileShareRequestMarshaller] GetInstance() {
        return [CreateSMBFileShareRequestMarshaller]::_instance
    }
}

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

class SetSMBGuestPasswordRequestMarshaller : AmazonWebServiceRequestMarshaller, IMarshaller`2[[IRequest], [SetSMBGuestPasswordRequest]] {
    [IRequest] Marshall([SetSMBGuestPasswordRequest] $PublicRequest) {
        [IRequest] $request = [DefaultRequest]::new($PublicRequest, 'Amazon.StorageGateway')
        $target = 'StorageGateway_20130630.SetSMBGuestPassword'
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

            if ($PublicRequest.IsSetPassword()) {
                $context.Writer.WritePropertyName('Password')
                $context.Writer.Write($PublicRequest.Password)
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

    hidden static [SetSMBGuestPasswordRequestMarshaller] $_instance = [SetSMBGuestPasswordRequestMarshaller]::new()

    static [SetSMBGuestPasswordRequestMarshaller] GetInstance() {
        return [SetSMBGuestPasswordRequestMarshaller]::_instance
    }
}

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

#### Abstract base classer for implementing multiple interfaces in PowerShell
class SMBFileShareInfoUnmarshallerBase : IUnmarshaller`2[[SMBFileShareInfo], [XmlUnmarshallerContext]] {
    [SMBFileShareInfo] Unmarshall([XmlUnmarshallerContext] $Context) {
        throw [NotImplementedException]::new()
    }
}

class SMBFileShareInfoUnmarshaller : SMBFileShareInfoUnmarshallerBase, IUnmarshaller`2[[SMBFileShareInfo], [JsonUnmarshallerContext]] {
    [SMBFileShareInfo] Unmarshall([JsonUnmarshallerContext] $Context) {
        $Context.Read()
        if ($Context.CurrentTokenType -eq [JsonToken]::Null) {
            return [SMBFileShareInfo] $null
        }

        $response = [SMBFileShareInfo]::new()
        $targetDepth = $Context.CurrentDepth
        while ($Context.ReadAtDepth($targetDepth)) {
            if ($Context.TestExpression('Authentication', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.Authentication = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('DefaultStorageClass', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.DefaultStorageClass = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('FileShareARN', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.FileShareARN = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('FileShareId', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.FileShareId = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('FileShareStatus', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.FileShareStatus = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('GatewayARN', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.GatewayARN = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('GuessMIMETypeEnabled', $targetDepth)) {
                $unmarshaller = [BoolUnmarshaller]::Instance
                $response.GuessMIMETypeEnabled = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('InvalidUserList', $targetDepth)) {
                [ListUnmarshaller[[string], [StringUnmarshaller]]]$listUnmarshaller = [ListUnmarshaller[[string], [StringUnmarshaller]]]::new([StringUnmarshaller]::Instance)
                $response.InvalidUserList = $listUnmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('KMSEncrypted', $targetDepth)) {
                $unmarshaller = [BoolUnmarshaller]::Instance
                $response.KMSEncrypted = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('KMSKey', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.KMSKey = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('LocationARN', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.LocationARN = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('ObjectACL', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.ObjectACL = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('Path', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.Path = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('ReadOnly', $targetDepth)) {
                $unmarshaller = [BoolUnmarshaller]::Instance
                $response.ReadOnly = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('RequesterPays', $targetDepth)) {
                $unmarshaller = [BoolUnmarshaller]::Instance
                $response.RequesterPays = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('Role', $targetDepth)) {
                $unmarshaller = [StringUnmarshaller]::Instance
                $response.Role = $unmarshaller.Unmarshall($Context)
                continue
            }

            if ($Context.TestExpression('ValidUserList', $targetDepth)) {
                [ListUnmarshaller[[string], [StringUnmarshaller]]]$listUnmarshaller = [ListUnmarshaller[[string], [StringUnmarshaller]]]::new([StringUnmarshaller]::Instance)
                $response.ValidUserList = $listUnmarshaller.Unmarshall($Context)
                continue
            }
        }
        return $response
    }

    hidden static [SMBFileShareInfoUnmarshaller] $_instance = [SMBFileShareInfoUnmarshaller]::new()

    static [SMBFileShareInfoUnmarshaller] GetInstance() {
        return [SMBFileShareInfoUnmarshaller]::_instance
    }
}

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

#endregion MarshallTransformations
