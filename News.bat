@echo off
chcp 65001 >nul
echo ========================================
echo  新建博客文章（自动时间命名）
echo ========================================
echo.

:: 获取当前时间，格式 yyyyMMddHHmm（如 202608091234）
for /f "tokens=*" %%i in ('powershell -command "Get-Date -Format 'yyyyMMddHHmm'"') do set fname=%%i

echo 正在创建文章：%fname%.md ...
hugo new content/posts/%fname%.md

if %errorlevel% neq 0 (
    echo.
    echo [错误] 创建失败，请确认 Hugo 已安装且目录正确。
    pause
    exit /b 1
)

echo [成功] 文件已创建，正在打开...
:: 用系统默认程序打开 Markdown 文件
start "" "content/posts/%fname%.md"

echo.
pause