@echo off
chcp 65001 >nul
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\deploy.ps1" %*

echo.
if errorlevel 1 (
    echo [失败] 部署未完成，请看上面的提示。
) else (
    echo [完成] 已推送到 GitHub，Vercel 将自动构建。
)
echo.
pause
