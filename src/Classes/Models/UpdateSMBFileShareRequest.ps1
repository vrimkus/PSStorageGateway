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