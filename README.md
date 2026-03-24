# PlanCheck - macOS 任务管理工具

[![Platform](https://img.shields.io/badge/platform-macOS%2015.0+-blue.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📖 项目简介

PlanCheck 是一款专为 macOS 设计的轻量级任务管理应用，采用纯 SwiftUI 开发，支持 iCloud 同步和本地文件同步。

### ✨ 核心特性

- **智能任务管理**：支持任务创建、编辑、删除、置顶等完整功能
- **灵活的日期策略**：自动转入未完成任务，支持自定义转入天数限制
- **iCloud 实时同步**：多设备数据自动同步
- **本地文件同步**：支持 iCloud Drive / OneDrive / 坚果云等第三方云盘同步
- **AI 自动复盘**：支持 GLM-5 云端模型和 Ollama 本地模型
- **批量操作**：支持鼠标多选、全选、滑动选择等高效操作
- **外部工具集成**：自动调用 Codex/Trae/CloudCode/OpenClaw 等 AI 编程工具

## 🚀 快速开始

### 系统要求

- macOS 15.0 或更高版本
- Xcode 16.0+（如果需要自行编译）

### 安装方式

#### 方式一：直接使用已编译应用

1. 下载 `PlanCheck_v2.4.dmg`
2. 拖拽到 Applications 文件夹
3. 启动应用

#### 方式二：自行编译

```bash
# 使用推荐的构建脚本
cd /path/to/plancheckCodexLingma
bash build_tools/final_build.sh
```

编译完成后会在项目根目录生成 `PlanCheck.app`

## 🔧 构建说明

### 使用 final_build.sh（推荐）

这是最简单直接的编译方式，无需 Xcode 项目文件：

```bash
bash build_tools/final_build.sh
```

该脚本会：
1. 使用 swiftc 直接编译所有 Swift 源文件
2. 自动处理依赖框架（SwiftUI、UserNotifications）
3. 创建应用包结构
4. 复制应用图标
5. 进行代码签名
6. 自动打开应用

### 其他构建文档

- [BUILD_GUIDE.md](build_tools/BUILD_GUIDE.md) - 详细构建指南
- [QUICK_START.md](build_tools/QUICK_START.md) - 快速入门
- [MIGRATION_REPORT.md](build_tools/MIGRATION_REPORT.md) - 迁移报告

## 📁 项目结构

```
plancheckCodexLingma/
├── plancheck/plancheck/     # 主要源代码
│   ├── plancheckApp.swift   # 应用入口
│   ├── ContentView.swift    # 主界面
│   ├── TodayView.swift      # 今日视图
│   ├── AllTasksView.swift   # 全部任务
│   ├── SettingsView.swift   # 设置页面
│   ├── TaskStore.swift      # 数据存储
│   └── ...
├── build_tools/             # 构建脚本
│   └── final_build.sh       # 推荐构建脚本
├── docs/                    # 项目文档
├── assets/icon/            # 应用图标
└── README.md               # 本文件
```

## 🎯 主要功能

### 1. 任务管理
- ✅ 创建任务：支持标题、预估时间、上下文、备注
- ✅ 编辑任务：双击或右键编辑
- ✅ 删除任务：回收到回收站，30 天后自动清理
- ✅ 置顶任务：重要任务置顶显示
- ✅ 批量操作：支持多选、全选、批量完成/删除

### 2. 视图分类
- 📅 **今日视图**：显示今天创建和转入的任务
- 📋 **全部任务**：查看所有历史任务
- ⭐ **重要任务**：查看置顶任务
- 🗑️ **回收站**：查看已删除任务

### 3. 数据同步
- ☁️ **iCloud 同步**：实时同步到 iCloud，支持多设备
- 📂 **本地文件同步**：支持自定义同步目录（适用于 iCloud Drive / OneDrive / 坚果云）
- 💾 **数据导入导出**：支持从备份文件导入任务数据

### 4. 自动化
- 🤖 **自动复盘**：每日/每周自动复盘任务完成情况
- 🔌 **外部工具集成**：启动任务后自动调用 AI 编程工具
- ⏰ **午夜自动转入**：每天午夜自动将未完成的任务转入次日

## 🛠️ 技术栈

- **语言**：Swift 6.0
- **框架**：SwiftUI, UserNotifications
- **架构**：MVVM
- **数据持久化**：JSON 文件存储
- **同步机制**：iCloud + 本地文件同步

## 📝 开发规范

### 编译要求

- **唯一推荐**：使用 `build_tools/final_build.sh` 进行编译
- **不使用**：Xcode 项目文件编译（xcodebuild）
- **原因**：项目采用模块化拆分，直接使用 swiftc 编译更简单高效

### Git 工作流

- 主分支：`main`
- 提交前确保编译通过
- 提交信息清晰描述变更内容

## 📄 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

感谢所有为 PlanCheck 做出贡献的开发者和用户！

---

**开发时间**: 2025-2026  
**维护者**: zytbft  
**GitHub**: [plancheckclaw](https://github.com/zytbft/plancheckclaw)
