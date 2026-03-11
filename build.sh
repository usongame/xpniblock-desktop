#!/bin/bash

# OpenBlock Desktop 构建脚本 (macOS/Linux)
# 使用方法: ./build.sh [command]
#
# 可用命令:
#   start       - 启动开发模式
#   dev         - 构建开发版本
#   dist        - 构建安装包（推荐）
#   publish     - 构建并发布到 GitHub Release
#   clean       - 清理构建文件

set -e

echo "========================================"
echo "  OpenBlock Desktop 构建脚本"
echo "========================================"

# 检查 Node.js 版本
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未安装 Node.js"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✅ Node.js 版本: $NODE_VERSION"

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: 未安装 npm"
    exit 1
fi

echo "✅ npm 版本: $(npm -v)"

# 安装依赖
install_deps() {
    echo ""
    echo "📦 安装依赖..."
    npm ci
}

# 启动开发模式
cmd_start() {
    echo ""
    echo "🚀 启动开发模式..."
    npm run start
}

# 构建开发版本
cmd_dev() {
    echo ""
    echo "🔨 构建开发版本..."
    install_deps
    npm run build:dev
    echo "✅ 开发版本构建完成！"
    echo "📁 输出目录: dist/"
}

# 构建安装包
cmd_dist() {
    echo ""
    echo "📦 构建安装包..."

    # 检查系统
    OS=$(uname -s)
    if [ "$OS" = "Darwin" ]; then
        echo "🍎 检测到 macOS"
        echo "   - 将生成 .dmg 安装包"
        echo "   - 如需发布到 App Store，请配置签名证书"
    elif [ "$OS" = "Linux" ]; then
        echo "🐧 检测到 Linux"
    fi

    install_deps

    # 下载资源文件
    echo "📥 下载资源文件..."
    npm run fetch:all

    # 构建
    npm run dist

    echo ""
    echo "========================================"
    echo "✅ 安装包构建完成！"
    echo "========================================"
    echo ""
    echo "📁 输出文件:"
    if [ "$OS" = "Darwin" ]; then
        ls -la dist/OpenBlock-Desktop*.dmg 2>/dev/null || true
    elif [ "$OS" = "Linux" ]; then
        ls -la dist/OpenBlock-Desktop*.AppImage 2>/dev/null || true
        ls -la dist/OpenBlock-Desktop*.deb 2>/dev/null || true
    fi
    echo ""
}

# 构建并发布
cmd_publish() {
    echo ""
    echo "🚀 构建并发布..."
    cmd_dist

    echo ""
    echo "📤 发布到 GitHub Release..."
    echo "   请确保已创建版本标签: git tag v.x.x.x && git push origin v.x.x.x"
    npm run publish
}

# 清理
cmd_clean() {
    echo ""
    echo "🧹 清理构建文件..."
    npm run clean
    echo "✅ 清理完成"
}

# 显示帮助
show_help() {
    echo ""
    echo "用法: ./build.sh [command]"
    echo ""
    echo "可用命令:"
    echo "  start       启动开发模式"
    echo "  dev         构建开发版本"
    echo "  dist        构建安装包 (推荐)"
    echo "  publish     构建并发布到 GitHub"
    echo "  clean       清理构建文件"
    echo ""
    echo "示例:"
    echo "  ./build.sh dist        # 构建安装包"
    echo "  ./build.sh start       # 启动开发模式"
    echo "  ./build.sh clean       # 清理"
    echo ""
}

# 主逻辑
case "${1:-help}" in
    start)
        cmd_start
        ;;
    dev)
        cmd_dev
        ;;
    dist)
        cmd_dist
        ;;
    publish)
        cmd_publish
        ;;
    clean)
        cmd_clean
        ;;
    *)
        show_help
        ;;
esac
