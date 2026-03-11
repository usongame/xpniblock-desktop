# OpenBlock Desktop

OpenBlock 桌面版应用程序

## 功能特点

- 图形化编程环境
- 支持多种硬件设备连接
- 积木式编程
- 支持 Scratch 项目导入导出

## 环境要求

- Node.js 16.x 或更高版本
- npm 8.x 或更高版本

## 安装依赖

```bash
npm ci
```

## 构建命令

### macOS / Linux

```bash
# 启动开发模式
./build.sh start

# 构建开发版本
./build.sh dev

# 构建安装包（推荐）
./build.sh dist

# 构建并发布到 GitHub
./build.sh publish

# 清理构建文件
./build.sh clean
```

### Windows

```cmd
REM 启动开发模式
build.cmd start

REM 构建开发版本
build.cmd dev

REM 构建安装包（推荐）
build.cmd dist

REM 构建并发布到 GitHub
build.cmd publish

REM 清理构建文件
build.cmd clean
```

## 输出文件

| 操作系统 | 输出文件 |
|---------|---------|
| **macOS** | `dist/OpenBlock-Desktop-*.dmg` |
| **Windows** | `dist/OpenBlock-Desktop-*-Setup.exe` |
| **Linux** | `dist/OpenBlock-Desktop-*.AppImage` |

## 发布到 Apple Store (macOS)

1. 在 Apple Developer 后台创建证书
2. 配置签名证书和 provisioning profile
3. 修改 `electron-builder.yaml` 中的 mac 配置
4. 使用 `npm run dist` 构建
5. 使用 Transporter 上传构建的应用

## 发布到 Microsoft Store (Windows)

1. 创建 Microsoft Developer 账户
2. 配置代码签名证书
3. 构建 MSIX 包
4. 在 Partner Center 提交应用

## 常见问题

### 构建失败

如果构建失败，请尝试：
```bash
# 清理 node_modules 和缓存
rm -rf node_modules
npm ci
```

### macOS 签名问题

确保在 Keychain 中安装了有效的开发者证书。

### Windows Defender 误报

对 exe 文件进行代码签名，或提交到 Microsoft 进行认证。

## 许可证

MIT License
