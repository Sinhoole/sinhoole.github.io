# new-post.ps1 — 新建博客文章（文件名：YYYYMMDD.md）
param(
    [Parameter(Mandatory = $true)]
    [string]$Title
)

$blogDir = "C:\Users\sinho\Desktop\CodingBlog\my-blog\content\blog"
$date     = Get-Date -Format "yyyyMMdd"
$filename = "$date.md"
$filepath = Join-Path $blogDir $filename

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
Start-Process "typora" $filepath
