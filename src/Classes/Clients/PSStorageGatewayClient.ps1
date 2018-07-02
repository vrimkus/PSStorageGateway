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