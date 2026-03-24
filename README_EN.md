# PlanCheck - macOS Task Management Tool

[![Platform](https://img.shields.io/badge/platform-macOS%2015.0+-blue.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📖 Introduction

PlanCheck is a lightweight task management application designed for macOS, built with pure SwiftUI, supporting iCloud synchronization and local file synchronization.

### ✨ Key Features

- **Smart Task Management**: Complete functionality for task creation, editing, deletion, pinning
- **Flexible Date Strategy**: Automatic carry-over of incomplete tasks with customizable day limits
- **iCloud Real-time Sync**: Automatic data synchronization across multiple devices
- **Local File Sync**: Support for third-party cloud drives like iCloud Drive / OneDrive / Jiguanyun
- **AI Auto Review**: Support for GLM-5 cloud model and Ollama local model
- **Batch Operations**: Mouse multi-selection, select all, slide selection and more
- **External Tool Integration**: Automatically call AI coding tools like Codex/Trae/CloudCode/OpenClaw

## 🚀 Quick Start

### System Requirements

- macOS 15.0 or later
- Xcode 16.0+ (if you need to compile yourself)

### Installation Methods

#### Method 1: Pre-compiled Application

1. Download `PlanCheck_v2.4.dmg`
2. Drag to Applications folder
3. Launch the app

#### Method 2: Self-compile

```bash
# Use recommended build script
cd /path/to/plancheckCodexLingma
bash build_tools/final_build.sh
```

After compilation, `PlanCheck.app` will be generated in the project root directory

## 🔧 Build Instructions

### Using final_build.sh (Recommended)

This is the simplest and most direct compilation method, no Xcode project file needed:

```bash
bash build_tools/final_build.sh
```

This script will:
1. Compile all Swift source files using swiftc
2. Automatically handle dependency frameworks (SwiftUI, UserNotifications)
3. Create application bundle structure
4. Copy application icon
5. Perform code signing
6. Automatically open the application

### Other Build Documentation

- [BUILD_GUIDE.md](build_tools/BUILD_GUIDE.md) - Detailed build guide
- [QUICK_START.md](build_tools/QUICK_START.md) - Quick start guide
- [MIGRATION_REPORT.md](build_tools/MIGRATION_REPORT.md) - Migration report

## 📁 Project Structure

```
plancheckCodexLingma/
├── plancheck/plancheck/     # Main source code
│   ├── plancheckApp.swift   # App entry point
│   ├── ContentView.swift    # Main interface
│   ├── TodayView.swift      # Today view
│   ├── AllTasksView.swift   # All tasks
│   ├── SettingsView.swift   # Settings page
│   ├── TaskStore.swift      # Data storage
│   └── ...
├── build_tools/             # Build scripts
│   └── final_build.sh       # Recommended build script
├── docs/                    # Project documentation
├── assets/icon/            # App icon
└── README.md               # This file
```

## 🎯 Main Features

### 1. Task Management
- ✅ Create tasks: Support title, estimated time, context, notes
- ✅ Edit tasks: Double-click or right-click to edit
- ✅ Delete tasks: Recycle to trash, auto-clean after 30 days
- ✅ Pin tasks: Important tasks pinned to top
- ✅ Batch operations: Multi-selection, select all, batch complete/delete

### 2. View Categories
- 📅 **Today View**: Tasks created and carried over today
- 📋 **All Tasks**: View all historical tasks
- ⭐ **Important Tasks**: View pinned tasks
- 🗑️ **Trash**: View deleted tasks

### 3. Data Synchronization
- ☁️ **iCloud Sync**: Real-time sync to iCloud, multi-device support
- 📂 **Local File Sync**: Custom sync directory (for iCloud Drive / OneDrive / Jiguanyun)
- 💾 **Data Import/Export**: Support importing task data from backup files

### 4. Automation
- 🤖 **Auto Review**: Daily/weekly automatic review of task completion
- 🔌 **External Tool Integration**: Automatically call AI coding tools after starting tasks
- ⏰ **Midnight Auto Carry-over**: Automatically carry over incomplete tasks to next day at midnight

## 🛠️ Tech Stack

- **Language**: Swift 6.0
- **Frameworks**: SwiftUI, UserNotifications
- **Architecture**: MVVM
- **Data Persistence**: JSON file storage
- **Sync Mechanism**: iCloud + local file sync

## 📝 Development Standards

### Build Requirements

- **Only Recommended**: Use `build_tools/final_build.sh` for compilation
- **Do Not Use**: Xcode project file compilation (xcodebuild)
- **Reason**: Project uses modular architecture, direct swiftc compilation is simpler and more efficient

### Git Workflow

- Main branch: `main`
- Ensure compilation passes before committing
- Commit messages should clearly describe changes

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Thanks to all developers and users who have contributed to PlanCheck!

---

**Development Time**: 2025-2026  
**Maintainer**: zytbft  
**GitHub**: [plancheckclaw](https://github.com/zytbft/plancheckclaw)
