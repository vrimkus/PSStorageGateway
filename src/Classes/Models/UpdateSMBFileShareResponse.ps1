class UpdateSMBFileShareResponse : AmazonWebServiceResponse {
    [string] $FileShareARN

    hidden [bool] IsSetFileShareARN() {
        return $this.FileShareARN -ne $null
    }
}