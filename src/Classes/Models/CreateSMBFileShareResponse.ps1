class CreateSMBFileShareResponse : AmazonWebServiceResponse {
    [string] $FileShareARN

    hidden [bool] IsSetFileShareARN() {
        return $this.FileShareARN -ne $null
    }
}