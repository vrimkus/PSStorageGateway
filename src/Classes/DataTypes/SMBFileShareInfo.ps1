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