# PlanCheck 构建 - 快速开始

## ⚠️ 重要说明

**本项目仅使用 `build_tools/final_build.sh` 进行构建**，其他所有构建脚本均已删除。

---

## 🚀 立即使用（3 步搞定）

### 第一步：打开终端
```bash
cd /Users/zyt/work/mycode/32plancheckCodexLingma
```

### 第二步：运行构建脚本（唯一方式）
```bash
./build_tools/final_build.sh
```

### 第三步：等待应用启动
看到 `✅ 编译成功！` 即可使用！

---

## 💡 常用场景

### 场景 1：日常开发，快速测试
```bash
./build_tools/final_build.sh
```
- ⏱️ 耗时：~30 秒
- 📦 产物：当前目录的 `PlanCheck.app`
- ✅ **唯一推荐方式**

---

### 场景 2：准备发布版本
```bash
# 1. 编译
./build_tools/final_build.sh

# 2. 打包 DMG
hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg
```
- ⏱️ 耗时：~1 分钟
- 📦 产物：`PlanCheck.app` + `PlanCheck_v2.4.dmg`
- ✅ **使用唯一构建脚本**

---

## ⚠️ 常见问题

### 提示 "Permission denied"
```bash
chmod +x build_tools/final_build.sh
```

### 提示 "应用已损坏"
```bash
xattr -cr PlanCheck.app
```

### 编译失败
确保使用的是唯一正确的构建脚本：
```bash
./build_tools/final_build.sh
```

> **注意**：不要尝试使用任何已删除的其他脚本（如 `xcode_build.sh`、`simple_build.sh`、`run_in_xcode.sh` 等）。

---

## 📋 完整文档

详细使用说明请查看：
- [构建工具说明](README.md) - **重点阅读**
- [完整编译指南](BUILD_GUIDE.md)

---

**最后更新**: 2026-03-24  
**构建方式**: 仅使用 `build_tools/final_build.sh` ⭐
