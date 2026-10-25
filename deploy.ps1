# deploy.ps1 — 构建 + 提交 + 推送
$ErrorActionPreference = "Stop"
# 始终以脚本所在目录为仓库根目录，避免换电脑/移动文件夹后路径失效
$blogDir = $PSScriptRoot

if (-not (Get-Command hugo -ErrorAction SilentlyContinue)) {
    Write-Host "hugo not found in PATH. 请先安装 Hugo 或把 hugo.exe 所在目录加入 PATH。" -ForegroundColor Red
    exit 1
}

Write-Host "`n[1/3] Hugo building..." -ForegroundColor Cyan
Push-Location $blogDir
hugo --gc --minify
if ($LASTEXITCODE -ne 0) { Write-Host "Build failed!" -ForegroundColor Red; Pop-Location; exit 1 }
Write-Host "  Build OK" -ForegroundColor Green

Write-Host "`n[2/3] Git commit..." -ForegroundColor Cyan
git add -A
if (-not (git diff --cached --quiet)) {
    git commit -m "deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    Write-Host "  Committed" -ForegroundColor Green
} else {
    Write-Host "  No changes" -ForegroundColor Yellow
}

Write-Host "`n[3/3] Git push..." -ForegroundColor Cyan
git push
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Pushed!" -ForegroundColor Green
} else {
    Write-Host "  Push failed — check credentials" -ForegroundColor Red
}
Pop-Location

Write-Host "`n  https://blog.taoxi.ink" -ForegroundColor Cyan
