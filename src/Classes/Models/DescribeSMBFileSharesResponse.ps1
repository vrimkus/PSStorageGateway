class DescribeSMBFileSharesResponse : AmazonWebServiceResponse {
    [List[SMBFileShareInfo]] $SMBFileShareInfoList = [List[SMBFileShareInfo]]::new()

    hidden [bool] IsSetSMBFileShareInfoList() {
        return ($this.SMBFileShareInfoList -and $this.SMBFileShareInfoList.Count -gt 0)
    }
}