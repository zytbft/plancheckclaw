# PlanCheck 构建工具

本目录包含用于编译和构建 PlanCheck 应用的脚本。

## 🚀 快速开始

### 日常开发 - 唯一推荐构建方式

```bash
./build_tools/final_build.sh
```

**产物位置**: `PlanCheck.app` (项目根目录)  
**耗时**: ~30 秒  
**特点**: 使用 swiftc 直接编译，无需 Xcode，包含所有必要的源文件和资源

---

## 📋 使用说明

### 1. 首次使用

添加执行权限：
```bash
chmod +x build_tools/final_build.sh
```

### 2. 构建应用

```bash
./build_tools/final_build.sh
```

### 3. 启动应用

```bash
open PlanCheck.app
```

---

## 🔧 故障排查

### 提示 "Permission denied"

```bash
chmod +x build_tools/final_build.sh
```

### 编译失败，提示缺少文件

确保所有 SwiftUI 文件都已添加到构建脚本中。如果添加了新文件，需要更新 `final_build.sh` 中的文件列表。

### 应用无法打开，提示 "已损坏"

移除隔离属性：
```bash
xattr -cr PlanCheck.app
```

### 通知权限问题

请在系统设置中确认应用的通知权限。

---

## 📦 技术说明

### 编译环境
- **SDK**: macOS 15.0+
- **架构**: arm64 (Apple Silicon)
- **Swift 版本**: 5.10+
- **依赖框架**: SwiftUI, UserNotifications

### 签名方式
使用 ad-hoc 签名 (`codesign --sign -`)，适合本地开发和测试。

---

## ⚠️ 注意事项

1. **新增文件**: 如果添加了新的 Swift 文件，需要更新 `final_build.sh` 中的文件列表
2. **权限问题**: 首次运行前需要添加执行权限 `chmod +x build_tools/final_build.sh`
3. **清理旧构建**: 每次构建会自动清理旧的产物，无需手动清理
4. **唯一构建脚本**: 本项目仅使用 `final_build.sh` 进行构建，其他构建脚本已删除

---

**最后更新**: 2026-03-24  
**验证状态**: ✅ `final_build.sh` 已成功验证
