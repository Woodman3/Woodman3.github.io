[CmdletBinding()]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]] $Text,

    [switch] $NoOpen
)

$ErrorActionPreference = 'Stop'

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$relativePath = "tweets/$timestamp.md"
$contentPath = Join-Path $PSScriptRoot "content/$relativePath"

& hugo new content $relativePath
if ($LASTEXITCODE -ne 0) {
    throw '创建推文失败，请确认 Hugo 已安装。'
}

if ($Text.Count -gt 0) {
    $tweetText = $Text -join ' '
    $content = Get-Content -LiteralPath $contentPath -Raw
    $content = $content.Replace('在这里写下此刻。', $tweetText)
    Set-Content -LiteralPath $contentPath -Value $content -Encoding utf8

    Write-Host "已创建推文：$relativePath" -ForegroundColor Green
    return
}

Write-Host "已创建推文：$relativePath" -ForegroundColor Green

if (-not $NoOpen) {
    $code = Get-Command code -ErrorAction SilentlyContinue
    if ($code) {
        & code --reuse-window $contentPath
    }
    else {
        Invoke-Item -LiteralPath $contentPath
    }
}

