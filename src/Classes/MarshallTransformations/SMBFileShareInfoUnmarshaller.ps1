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