@echo off
chcp 65001 >nul
echo ========================================
echo  博客推送脚本（仅提交+推送）
echo ========================================
echo.

echo [1/2] 提交到 Git...
git add -A
git commit -m "更新博客"
echo.

echo [2/2] 推送到 GitHub...
git push
if %errorlevel% equ 0 (
    echo.
    echo [成功] 已推送到远程仓库！
    echo        https://blog.taoxi.ink
) else (
    echo.
    echo [错误] 推送失败，请检查网络或仓库状态。
    echo 若尚未提交，可先手动 git add / git commit 再试。
)

echo.
pause