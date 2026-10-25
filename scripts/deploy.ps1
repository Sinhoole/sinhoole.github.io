#Requires -Version 5.1
<#
.SYNOPSIS
    一键部署：Hugo 构建 → git add/commit → git push（Vercel 会自动重新构建）。

.DESCRIPTION
    - 构建失败会中止，不会提交半成品。
    - 没有改动时只做 push（比如只是本地提交过）。
    - 推送前会检查 DNS 是否被 Clash 的 fake-ip 接管（198.18.x），那是 TUN 模式，SSH 推送必然失败。
    - 需要 git 与 hugo 在 PATH 里（已配置）。

.EXAMPLE
    .\Deploy.bat
    .\scripts\deploy.ps1 -Message "新增文章：山与海"
#>
param(
    [string]$Message
)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { }

$root = Split-Path -Parent $PSScriptRoot   # scripts 的上一级 = 仓库根目录
Set-Location $root

$siteUrl = 'https://blog.taoxi.ink'

# ---------- 前置检查 ----------
foreach ($tool in 'hugo', 'git') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Host "[错误] 找不到 $tool，请检查 PATH。" -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path (Join-Path $root 'hugo.toml'))) {
    Write-Host "[错误] 当前目录不是 Hugo 站点根目录：$root" -ForegroundColor Red
    exit 1
}

# Clash TUN(fake-ip) 会让 SSH 推送失败，提前提示
try {
    $dns = Resolve-DnsName 'github.com' -Type A -ErrorAction Stop |
           Where-Object { $_.IPAddress } | Select-Object -ExpandProperty IPAddress
    if ($dns -match '^198\.18\.') {
        Write-Host '[注意] 当前 github.com 解析到 198.18.x（Clash「虚拟网卡/TUN」模式的 fake-ip）。' -ForegroundColor Yellow
        Write-Host '       这会让 SSH 推送失败，建议先关掉 TUN 模式再部署。' -ForegroundColor Yellow
        Write-Host ''
    }
} catch { }

# ---------- 1/3 构建 ----------
Write-Host "[1/3] Hugo 构建中…" -ForegroundColor Cyan
hugo --gc --minify
if ($LASTEXITCODE -ne 0) {
    Write-Host '       构建失败，已中止（未提交、未推送）。' -ForegroundColor Red
    exit 1
}
Write-Host '       构建通过' -ForegroundColor Green

# ---------- 2/3 提交 ----------
Write-Host "[2/3] Git 提交…" -ForegroundColor Cyan
git add -A
if ($LASTEXITCODE -ne 0) { Write-Host '       git add 失败' -ForegroundColor Red; exit 1 }

$hasChanges = -not (git diff --cached --quiet)
if ($hasChanges) {
    if (-not $Message) { $Message = '更新博客 ' + (Get-Date -Format 'yyyy-MM-dd HH:mm') }
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { Write-Host '       git commit 失败' -ForegroundColor Red; exit 1 }
    Write-Host "       已提交：$Message" -ForegroundColor Green
} else {
    Write-Host '       没有新改动，跳过提交' -ForegroundColor Yellow
}

# ---------- 3/3 推送 ----------
Write-Host "[3/3] 推送到 GitHub…" -ForegroundColor Cyan
git push
if ($LASTEXITCODE -ne 0) {
    Write-Host '       推送失败。若报 "Connection closed by 198.18.x"，请关闭 Clash TUN 模式后重试；' -ForegroundColor Red
    Write-Host '       若报 "Permission denied (publickey)"，说明 SSH 公钥未加到 GitHub。' -ForegroundColor Red
    exit 1
}
Write-Host '       推送成功，Vercel 会自动构建' -ForegroundColor Green

$head = (git log -1 --pretty=format:'%h %s')
Write-Host ''
Write-Host "最近提交：$head" -ForegroundColor DarkGray
Write-Host "线上地址：$siteUrl" -ForegroundColor Cyan
