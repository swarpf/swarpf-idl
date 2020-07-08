Param(
    [switch]$Debug
)

$GOPATH = $env:GOPATH
$GO_BIN_PATH = Join-Path $GOPATH "bin"

$PROTOC_AVAILABLE = Get-Command "protoc.exe" -ErrorAction SilentlyContinue
$PROTOC_GEN_GO_EXE = Join-Path $GO_BIN_PATH "protoc-gen-go.exe"
$PROTOC_GEN_GO_GRPC_EXE = Join-Path $GO_BIN_PATH "protoc-gen-go-grpc.exe"

if ($Debug.IsPresent)
{
    Write-Host "GOPATH: $GOPATH"
    Write-Host "GO_BIN_PATH: $GO_BIN_PATH"
    Write-Host "PROTOC_GEN_GO_EXE: $PROTOC_GEN_GO_EXE"
    Write-Host "PROTOC_GEN_GO_GRPC_EXE: $PROTOC_GEN_GO_GRPC_EXE"
}

if (!($GOPATH || Test-Path $GOPATH))
{
    Throw "Could not find GOPATH"
}

if (!$PROTOC_AVAILABLE)
{
    Throw "Could not find protoc.exe"
}

if (!($PROTOC_GEN_GO_EXE || Test-Path $PROTOC_GEN_GO_EXE))
{
    Throw "Could not find protoc-gen-go.exe"
}

if (!($PROTOC_GEN_GO_GRPC_EXE || Test-Path $PROTOC_GEN_GO_GRPC_EXE))
{
    Throw "Could not find protoc-gen-go-grpc.exe"
}

$protogen_go_path = "./proto-gen-go"
If (!(Test-Path -Path $protogen_go_path))
{
    New-Item -ItemType Directory -Path $protogen_go_path
}

Invoke-Expression "protoc -I=`"./proto/api`" --go_out=$protogen_go_path/ ./proto/api/proxyapi.proto"
Invoke-Expression "protoc -I=`"./proto/api`" --go-grpc_out=$protogen_go_path/ ./proto/api/proxyapi.proto"
