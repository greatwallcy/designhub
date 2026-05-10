@echo off
chcp 65001 >nul
cd /d G:\AI\designhub

echo ========================================
echo   DesignHub 一键构建部署
echo ========================================
echo.

REM ===== 步骤1：构建 =====
echo [1/4] 正在构建项目...
cd phase2
call npm run build
if %errorlevel% neq 0 (
    echo [错误] 构建失败！
    pause
    exit /b 1
)
cd ..

REM ===== 步骤2：清空旧资源 =====
echo.
echo [2/4] 正在清空旧资源...
if exist assets (
    attrib -h -s -r assets\*.* /s /d >nul 2>&1
    for /f "delims=" %%i in ('dir /b /ad assets 2^>nul') do (
        rd /s /q "assets\%%i" 2>nul
    )
    del /q assets\*.* 2>nul
)
echo     已清空旧资源

REM ===== 步骤3：复制新构建 =====
echo.
echo [3/4] 正在复制新构建...
xcopy phase2\dist\* . /e /h /r /y >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 复制失败！
    pause
    exit /b 1
)
echo     复制完成

REM ===== 步骤4：提交并推送 =====
echo.
echo [4/4] 正在提交并推送到 GitHub...
git add -A
git status --short >nul 2>&1
if %errorlevel% neq 0 (
    echo     没有需要提交的内容
) else (
    git commit -m "deploy: %date% %time%"
    if %errorlevel% neq 0 (
        echo [错误] 提交失败！
        pause
        exit /b 1
    )
    git push origin master:gh-pages --force
    if %errorlevel% neq 0 (
        echo [错误] 推送失败！请检查网络或 GitHub Token
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo   部署完成！
echo   网站地址：https://greatwallcy.github.io/designhub/
echo ========================================
echo.
pause
