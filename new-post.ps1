param(
    [string]$Title
)

# 获取博客根目录
$BlogDir = Split-Path -Parent $PSScriptRoot

# 如果没传标题，交互输入
if (-not $Title) {
    $Title = Read-Host "请输入文章标题"
}

if (-not $Title) {
    Write-Host "❌ 标题不能为空" -ForegroundColor Red
    exit 1
}

# 生成日期和文件名
$Date = Get-Date -Format "yyyy-MM-dd"
$Slug = $Title -replace '[^\w\u4e00-\u9fff]', '-' -replace '-+', '-' -replace '^-|-$', ''
$FileName = "$Date-$Slug.md"
$FilePath = Join-Path $BlogDir "content\blog\$FileName"

# 检查是否已存在
if (Test-Path $FilePath) {
    Write-Host "⚠️ 文件已存在: $FileName" -ForegroundColor Yellow
    $Overwrite = Read-Host "是否覆盖？(y/N)"
    if ($overwrite -ne 'y') { exit 0 }
}

# 生成 Hugo front matter
$Content = @"
---
title: '$Title'
date: $Date
draft: true
tags:
  - 
categories:
  - 
---

"@

# 写入文件
Set-Content -Path $FilePath -Value $Content -Encoding UTF8

Write-Host "✅ 文章已创建: $FileName" -ForegroundColor Green
Write-Host "   📄 $FilePath" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 用 Typora 打开..." -ForegroundColor Yellow

# 用 Typora 打开
if (Get-Command typora -ErrorAction SilentlyContinue) {
    typora $FilePath
} elseif (Test-Path "C:\Program Files\Typora\Typora.exe") {
    Start-Process "C:\Program Files\Typora\Typora.exe" $FilePath
} else {
    Write-Host "   Typora 未找到，请在编辑器手动打开文件" -ForegroundColor Gray
    Invoke-Item $FilePath
}

Write-Host ""
Write-Host "写完记得修改 draft: false，然后运行推送脚本上传" -ForegroundColor Cyan
