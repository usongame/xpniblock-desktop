@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   OpenBlock Desktop 构建脚本
echo ========================================
echo.

:: 检查 Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 错误: 未安装 Node.js
    exit /b 1
)

for /f "tokens=*" %%i in ('node -v') do set NODE_VERSION=%%i
echo ✅ Node.js 版本: %NODE_VERSION%

for /f "tokens=*" %%i in ('npm -v') do set NPM_VERSION=%%i
echo ✅ npm 版本: %NPM_VERSION%
echo.

:: 安装依赖
:install_deps
echo.
echo 📦 安装依赖...
call npm ci
goto :eof

:: 启动开发模式
:cmd_start
echo.
echo 🚀 启动开发模式...
call npm run start
goto :eof

:: 构建开发版本
:cmd_dev
echo.
echo 🔨 构建开发版本...
call npm run build:dev
echo ✅ 开发版本构建完成！
echo 📁 输出目录: dist\
goto :eof

:: 构建安装包
:cmd_dist
echo.
echo 📦 构建安装包...

:: 下载资源文件
echo 📥 下载资源文件...
call npm run fetch:all

:: 构建
call npm run dist

echo.
echo ========================================
echo ✅ 安装包构建完成！
echo ========================================
echo.
echo 📁 输出文件:
dir /b dist\OpenBlock-Desktop*.exe 2>nul
dir /b dist\OpenBlock-Desktop*.msi 2>nul
echo.
goto :eof

:: 构建并发布
:cmd_publish
echo.
echo 🚀 构建并发布...
call :cmd_dist
echo.
echo 📤 发布到 GitHub Release...
echo    请确保已创建版本标签: git tag v.x.x.x ^&^& git push origin v.x.x.x
call npm run publish
goto :eof

:: 清理
:cmd_clean
echo.
echo 🧹 清理构建文件...
call npm run clean
echo ✅ 清理完成
goto :eof

:: 显示帮助
:show_help
echo.
echo 用法: build.cmd [command]
echo.
echo 可用命令:
echo   start       启动开发模式
echo   dev         构建开发版本
echo   dist        构建安装包 ^(推荐^)
echo   publish     构建并发布到 GitHub
echo   clean       清理构建文件
echo.
echo 示例:
echo   build.cmd dist        # 构建安装包
echo   build.cmd start       # 启动开发模式
echo   build.cmd clean       # 清理
echo.
goto :eof

:: 主逻辑
if "%1"=="" goto show_help
if "%1"=="start" goto cmd_start
if "%1"=="dev" goto cmd_dev
if "%1"=="dist" goto cmd_dist
if "%1"=="publish" goto cmd_publish
if "%1"=="clean" goto cmd_clean

echo 未知命令: %1
echo.
goto show_help
