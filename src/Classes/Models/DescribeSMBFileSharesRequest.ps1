class DescribeSMBFileSharesRequest : AmazonStorageGatewayRequest {
    [List[string]] $FileShareARNList = [List[string]]::new()

    hidden [bool] IsSetFileShareARNList() {
        return ($this.FileShareARNList -and $this.FileShareARNList.Count -gt 0)
    }
}