# new-post.ps1 — 新建博客文章（文件名：YYYYMMDD.md）
param(
    [Parameter(Mandatory = $true)]
    [string]$Title
)

# 脚本所在目录下的 content/blog，换电脑/移动文件夹后依然可用
$blogDir = Join-Path $PSScriptRoot "content\blog"
if (-not (Test-Path $blogDir)) { New-Item -ItemType Directory -Path $blogDir -Force | Out-Null }

$date     = Get-Date -Format "yyyyMMdd"
$filename = "$date.md"
$filepath = Join-Path $blogDir $filename

# 同一天多篇：YYYYMMDD.md 已存在时改用 YYYYMMDD-01.md、YYYYMMDD-02.md …
if (Test-Path $filepath) {
    $n = 1
    do {
        $filename = "{0}-{1:D2}.md" -f $date, $n
        $filepath = Join-Path $blogDir $filename
        $n++
    } while (Test-Path $filepath)
}

$frontMatter = @"
---
title: '$Title'
date: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')
draft: true
tags: []
categories: []
---

"@

Set-Content -Path $filepath -Value $frontMatter -Encoding UTF8
Write-Host "Created: $filepath" -ForegroundColor Green

# 打开编辑器：优先 PATH 里的 typora，其次常见安装位置，最后交给系统默认程序
$typora = Get-Command typora -ErrorAction SilentlyContinue
if ($typora) {
    Start-Process $typora.Source $filepath
    return
}
$candidates = @(
    'C:\DATA\SoftWares\Typora\Typora\Typora.exe',
    "$env:LOCALAPPDATA\Programs\Typora\Typora.exe",
    'C:\Program Files\Typora\Typora.exe'
)
$found = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($found) { Start-Process $found $filepath } else { Start-Process $filepath }
