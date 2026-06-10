@echo off
chcp 65001 >nul

:: 文章目录（请根据你的实际路径确认）
set "targetDir=C:\Users\sinho\Desktop\CodingBlog\my-blog\content\blog"

:: 确保目录存在
if not exist "%targetDir%" mkdir "%targetDir%"

:: 获取当前时间戳，如 202606081234
for /f "tokens=*" %%i in ('powershell -command "Get-Date -Format 'yyyyMMddHHmm'"') do set fname=%%i

set "filepath=%targetDir%\%fname%.md"

echo ========================================
echo  新建博客文章（自动时间命名）
echo ========================================
echo.
echo 目标文件夹: %targetDir%
echo 文件名: %fname%.md
echo.

:: 生成 front matter 并写入文件
(
echo ---
echo title: "待输入"
echo date: %fname:~0,4%-%fname:~4,2%-%fname:~6,2%T%fname:~8,2%:%fname:~10,2%:00+08:00
echo draft: false
echo tags: []
echo categories: []
echo ---
echo.
echo 开始写作...
) > "%filepath%"

echo [成功] 文件已创建，正在打开...
start "" "%filepath%"

echo.
pause