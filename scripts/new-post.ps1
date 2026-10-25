#Requires -Version 5.1
<#
.SYNOPSIS
    新建一篇 PaperMod 文章（YYYYMMDD.md），写入完整 front matter，draft 直接为 false，并自动打开编辑。

.DESCRIPTION
    文件名遵循本仓库约定：content/blog/YYYYMMDD.md；同一天第二篇起用 YYYYMMDD-01.md、-02.md……
    permalink 由 hugo.toml 的 `blog = '/p/:contentbasename/'` 决定，所以改文件名会影响链接。

.EXAMPLE
    .\scripts\new-post.ps1 -Title "山与海"
    .\scripts\new-post.ps1 -Title "山与海" -Tags "旅行,随笔" -Categories "随笔" -NoOpen
#>
param(
    [string]$Title,
    [string]$Tags,
    [string]$Categories,
    [string]$Summary,
    [switch]$NoOpen
)

$ErrorActionPreference = 'Stop'

# 中文提示在 UTF-8 控制台下正常显示
try {
    [Console]::OutputEncoding = [Text.Encoding]::UTF8
    [Console]::InputEncoding  = [Text.Encoding]::UTF8
} catch { }

# ---------- 路径 ----------
$root    = Split-Path -Parent $PSScriptRoot          # scripts 的上一级 = 仓库根目录
$blogDir = Join-Path $root 'content\blog'
if (-not (Test-Path $blogDir)) { New-Item -ItemType Directory -Path $blogDir -Force | Out-Null }

# ---------- 交互 ----------
if (-not $Title) { $Title = Read-Host '文章标题' }
$Title = ($Title -replace '\s+', ' ').Trim().Trim('"', "'").Trim()
if (-not $Title) { Write-Host '标题不能为空，已取消。' -ForegroundColor Red; exit 1 }

if (-not $PSBoundParameters.ContainsKey('Tags')) { $Tags = '' }
if (-not $PSBoundParameters.ContainsKey('Categories')) { $Categories = '' }

function Split-List([string]$raw) {
    if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
    return @($raw -split '[,，;；]' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$tagList  = Split-List $Tags
$catList  = Split-List $Categories
$summary  = if ($Summary) { $Summary.Trim() } else { '' }

# ---------- 文件名：YYYYMMDD.md，同日避免覆盖 ----------
$day  = Get-Date -Format 'yyyyMMdd'
$name = $day
$file = Join-Path $blogDir "$name.md"
$n = 1
while (Test-Path $file) {
    $name = '{0}-{1:D2}' -f $day, $n
    $file = Join-Path $blogDir "$name.md"
    $n++
}

# ---------- YAML 取值转义 ----------
function ConvertTo-YamlString([string]$value) {
    if ($null -eq $value) { return '""' }
    return '"' + $value.Replace('\', '\\').Replace('"', '\"') + '"'
}
function ConvertTo-YamlList([string[]]$items) {
    if (-not $items -or $items.Count -eq 0) { return '[]' }
    return '[' + (($items | ForEach-Object { ConvertTo-YamlString $_ }) -join ', ') + ']'
}

# ---------- PaperMod front matter ----------
$now = Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'
$fm  = @()
$fm += '---'
$fm += 'title: '        + (ConvertTo-YamlString $Title)
$fm += 'date: '         + $now
$fm += 'draft: false'
$fm += 'author: "Ta0X1"'
$fm += 'tags: '         + (ConvertTo-YamlList $tagList)
$fm += 'categories: '   + (ConvertTo-YamlList $catList)
if ($summary) { $fm += 'summary: ' + (ConvertTo-YamlString $summary) }
$fm += 'ShowToc: true'
$fm += 'TocOpen: true'
$fm += 'ShowReadingTime: true'
$fm += 'ShowWordCount: true'
$fm += 'ShowBreadCrumbs: true'
$fm += 'ShowPostNavLinks: true'
$fm += 'comments: true'
$fm += 'searchHidden: false'
$fm += ''
$fm += '# 需要封面图时取消下面注释（image 可写 URL，也可写 static/ 下的相对路径）'
$fm += '# cover:'
$fm += '#   image: ""'
$fm += '#   alt: ""'
$fm += '#   caption: ""'
$fm += '#   relative: false'
$fm += '---'
$fm += ''
$fm += '在这里开始写正文……'
$fm += ''

$content = ($fm -join "`r`n")

# 必须是无 BOM 的 UTF-8：带 BOM 时 Hugo 的 YAML front matter 可能解析失败
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText($file, $content, $utf8NoBom)

$rel = $file.Substring($root.Length).TrimStart('\')
Write-Host ''
Write-Host "已创建: $rel" -ForegroundColor Green
Write-Host "链接:   https://blog.taoxi.ink/p/$name/" -ForegroundColor DarkGray

# ---------- 用 Typora 打开（找不到就交给系统默认程序）----------
if (-not $NoOpen) {
    $opened = $false
    $cmd = Get-Command typora -ErrorAction SilentlyContinue
    if ($cmd) { Start-Process $cmd.Source $file; $opened = $true }
    if (-not $opened) {
        $candidates = @(
            'C:\DATA\SoftWares\Typora\Typora\Typora.exe',
            "$env:LOCALAPPDATA\Programs\Typora\Typora.exe",
            'C:\Program Files\Typora\Typora.exe'
        )
        $found = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
        if ($found) { Start-Process $found $file; $opened = $true }
    }
    if (-not $opened) { Start-Process $file }
}
