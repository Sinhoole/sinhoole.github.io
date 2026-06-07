# 先构建
Write-Host "🏗️  构建站点..." -ForegroundColor Yellow
hugo

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 构建失败，请检查错误信息" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 构建成功" -ForegroundColor Green

# 提交 Git
Write-Host "📤 提交到 Git..." -ForegroundColor Yellow
git add -A
git commit -m "更新博客"

# 推送
Write-Host "🚀 推送到 GitHub..." -ForegroundColor Yellow
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 已成功发布！" -ForegroundColor Green
    Write-Host "   https://sinhoole.github.io" -ForegroundColor Cyan
} else {
    Write-Host "❌ 推送失败，请手动执行 git push" -ForegroundColor Red
}
