[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Title,

    [switch] $NoOpen
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Title)) {
    $Title = Read-Host '文章标题'
}

if ([string]::IsNullOrWhiteSpace($Title)) {
    throw '文章标题不能为空。'
}

$relativePath = "post/draft/$Title/index.md"
& hugo new content $relativePath
if ($LASTEXITCODE -ne 0) {
    throw '创建博文草稿失败，请确认 Hugo 已安装。'
}

$contentPath = Join-Path $PSScriptRoot "content/$relativePath"
Write-Host "已创建草稿：content/$relativePath" -ForegroundColor Green

if (-not $NoOpen) {
    $code = Get-Command code -ErrorAction SilentlyContinue
    if ($code) {
        & code --reuse-window $contentPath
    }
    else {
        Invoke-Item -LiteralPath $contentPath
    }
}

