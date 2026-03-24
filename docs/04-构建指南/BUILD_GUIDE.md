# PlanCheck 编译打包指南

## 📋 目录

1. [快速开始](#快速开始)
2. [完整编译打包流程](#完整编译打包流程)
3. [分步命令详解](#分步命令详解)
4. [常见问题排查](#常见问题排查)
5. [版本发布清单](#版本发布清单)

---

## 🚀 快速开始

### 一键编译打包（推荐）

```bash
# 步骤 1: 编译生成 PlanCheck.app
cd /Users/zyt/work/mycode/32plancheckCodexLingma && bash build_tools/final_build.sh 2>&1

# 步骤 2: 打包成 DMG 文件
cd /Users/zyt/work/mycode/32plancheckCodexLingma && hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg
```

**产物位置**:
- `PlanCheck.app` - 应用程序包（项目根目录）
- `PlanCheck_v2.4.dmg` - 安装镜像（项目根目录）

---

## 🔧 完整编译打包流程

### 方案一：使用 final_build.sh（推荐）⭐

这是最快速、最可靠的构建方式，适合日常开发和版本发布。

#### 执行步骤

```bash
# 1️⃣ 切换到项目根目录
cd /Users/zyt/work/mycode/32plancheckCodexLingma

# 2️⃣ 运行构建脚本
bash build_tools/final_build.sh 2>&1

# 3️⃣ 等待编译完成（约 30-60 秒）
# 看到 "✅ 完成！" 表示成功

# 4️⃣ 验证 App 是否生成
ls -lh PlanCheck.app/Contents/MacOS/plancheck

# 5️⃣ 打包成 DMG（可选，用于分发）
hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg

# 6️⃣ 验证 DMG 文件
ls -lh PlanCheck_v2.4.dmg
```

#### 完整的一键命令

```bash
# 复制这条命令即可一次性完成编译和打包
cd /Users/zyt/work/mycode/32plancheckCodexLingma && bash build_tools/final_build.sh 2>&1 && hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg
```

#### 预期输出示例

```
=== 编译 PlanCheck ===
正在编译...
正在签名...
✅ 完成！
📦 App: /Users/zyt/work/mycode/32plancheckCodexLingma/PlanCheck.app

created: /Users/zyt/work/mycode/32plancheckCodexLingma/PlanCheck_v2.4.dmg
```

---

### 方案二：分步执行（用于调试）

如果需要更细致的控制或排查问题，可以分步执行。

#### 第 1 步：编译 App

```bash
cd /Users/zyt/work/mycode/32plancheckCodexLingma
bash build_tools/final_build.sh 2>&1
```

**检查点**:
- ✅ 无编译错误
- ✅ 生成 `PlanCheck.app`
- ✅ App 大小约 3-4MB

#### 第 2 步：测试 App（可选）

```bash
open PlanCheck.app
```

**检查点**:
- ✅ App 能正常启动
- ✅ 新功能运行正常
- ✅ 界面无异常

#### 第 3 步：打包 DMG

```bash
hdiutil create -volname "PlanCheck" \
  -srcfolder PlanCheck.app \
  -ov \
  -format UDZO \
  PlanCheck_v2.4.dmg
```

**参数说明**:
- `-volname "PlanCheck"`: 挂载后的卷标名称
- `-srcfolder PlanCheck.app`: 源文件夹路径
- `-ov`: 覆盖已存在的 DMG 文件
- `-format UDZO`: 压缩格式（推荐）

#### 第 4 步：验证 DMG（可选）

```bash
# 查看 DMG 文件大小
ls -lh PlanCheck_v2.4.dmg

# 挂载 DMG 测试
hdiutil attach PlanCheck_v2.4.dmg

# 卸载 DMG
hdiutil detach /Volumes/PlanCheck
```

---

## 📖 分步命令详解

### 编译命令解析

```bash
cd /Users/zyt/work/mycode/32plancheckCodexLingma && bash build_tools/final_build.sh 2>&1
```

| 部分                                               | 说明                                           |
| -------------------------------------------------- | ---------------------------------------------- |
| `cd /Users/zyt/work/mycode/32plancheckCodexLingma` | 切换到项目根目录                               |
| `&&`                                               | 前一个命令成功后执行下一个                     |
| `bash build_tools/final_build.sh`                  | 执行构建脚本                                   |
| `2>&1`                                             | 将错误输出重定向到标准输出（便于查看完整日志） |

### 打包命令解析

```bash
hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg
```

| 参数                       | 说明             |
| -------------------------- | ---------------- |
| `hdiutil create`           | 创建磁盘镜像     |
| `-volname "PlanCheck"`     | 设置卷标名称     |
| `-srcfolder PlanCheck.app` | 指定源文件夹     |
| `-ov`                      | 覆盖已存在的文件 |
| `-format UDZO`             | 使用压缩格式     |
| `PlanCheck_v2.4.dmg`       | 输出文件名       |

---

## ⚠️ 常见问题排查

### 1. 编译失败：找不到源文件

**错误信息**:
```
error opening input file 'plancheck/plancheck/XXX.swift' (No such file or directory)
```

**原因**: 构建脚本路径问题

**解决方案**:
```bash
# 确保在项目根目录执行
cd /Users/zyt/work/mycode/32plancheckCodexLingma
bash build_tools/final_build.sh
```

### 2. 权限不足

**错误信息**:
```
Permission denied
```

**解决方案**:
```bash
chmod +x build_tools/final_build.sh
bash build_tools/final_build.sh
```

### 3. App 无法打开，提示"已损坏"

**错误信息**:
```
"PlanCheck.app" is damaged and can't be opened.
```

**解决方案**:
```bash
# 移除隔离属性
xattr -cr PlanCheck.app

# 重新签名
codesign --force --deep --sign - PlanCheck.app

# 再次尝试打开
open PlanCheck.app
```

### 4. DMG 打包失败

**错误信息**:
```
create: File exists
```

**解决方案**:
```bash
# 删除旧 DMG 或使用 -ov 参数覆盖
rm PlanCheck_v2.4.dmg
hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg
```

### 5. 编译时间过长

**正常情况**: 30-60 秒  
**异常情况**: 超过 2 分钟

**排查步骤**:
```bash
# 1. 检查磁盘空间
df -h

# 2. 关闭其他占用资源的应用

# 3. 清理临时文件
rm -rf PlanCheck.app
bash build_tools/final_build.sh
```

---

## 📦 版本发布清单

### 发布前检查清单

- [ ] 代码已使用 MCP GitHub 工具提交
- [ ] 已通过功能测试
- [ ] 已更新版本号（如适用）
- [ ] 已清理调试代码
- [ ] 已备份重要数据

### 代码提交流程

**重要**：本项目使用 MCP GitHub 工具进行所有代码提交，禁止使用传统 Git 命令。

#### 使用 MCP GitHub 工具（必需）

```typescript
// AI 助手环境中的示例
await mcp_github_push_files({
  owner: "zytbft",
  repo: "plancheckclaw",
  branch: "main",
  files: [
    {
      path: "plancheck/plancheck/YourFile.swift",
      content: "// 你的代码"
    }
  ],
  message: "feat: 描述你的改动"
});
```

**为什么使用 MCP GitHub 工具？**
- ✅ 确保一致的提交历史
- ✅ 自动验证和测试
- ✅ 与 AI 助手工作流集成
- ✅ 正确的文件跟踪和差异管理

**提交参数说明**：
| 参数 | 说明 | 示例 |
|------|------|------|
| `owner` | GitHub 仓库所有者 | `"zytbft"` |
| `repo` | 仓库名称 | `"plancheckclaw"` |
| `branch` | 分支名称 | `"main"` |
| `files` | 要提交的文件数组 | `[...]` |
| `message` | 提交信息 | `"feat: 新增功能"` |

**文件格式**：
```typescript
{
  path: "文件相对路径",
  content: "文件完整内容"
}
```

#### 传统 Git 命令（仅限紧急情况）

仅在 MCP 工具不可用时的应急方案：

```bash
# ⚠️ 仅在 MCP 工具失败时使用
cd /Users/zyt/work/mycode/32plancheckCodexLingma
git add <文件>
git commit -m "描述"
git push origin main
```

### 发布步骤

```bash
# 1. 确认版本号（例如 v2.4）
VERSION="2.4"

# 2. 编译 App
cd /Users/zyt/work/mycode/32plancheckCodexLingma
bash build_tools/final_build.sh 2>&1

# 3. 验证 App 功能
open PlanCheck.app

# 4. 打包 DMG
hdiutil create -volname "PlanCheck" \
  -srcfolder PlanCheck.app \
  -ov \
  -format UDZO \
  PlanCheck_v${VERSION}.dmg

# 5. 验证 DMG
hdiutil attach PlanCheck_v${VERSION}.dmg
# 检查应用是否正常
hdiutil detach /Volumes/PlanCheck

# 6. 计算校验和（用于验证文件完整性）
shasum -a 256 PlanCheck_v${VERSION}.dmg

# 7. 分发 DMG 文件
```

### 产物验证

```bash
# 检查文件大小
ls -lh PlanCheck_v2.4.dmg
# 正常大小：2-3MB

# 检查 App 结构
ls -la PlanCheck.app/Contents/MacOS/
# 应该包含：plancheck (可执行文件)

# 检查签名
codesign --verify PlanCheck.app
# 无输出表示签名正常
```

---

## 💡 最佳实践

### 日常开发

```bash
# 快速编译测试
bash build_tools/final_build.sh

# 如果修改了代码，先清理再编译
rm -rf PlanCheck.app
bash build_tools/final_build.sh
```

### 版本发布

```bash
# 完整编译 + 打包 + 验证
bash build_tools/final_build.sh && \
hdiutil create -volname "PlanCheck" -srcfolder PlanCheck.app -ov -format UDZO PlanCheck_v2.4.dmg && \
echo "✅ 打包完成！DMG 文件：$(pwd)/PlanCheck_v2.4.dmg"
```

### 批量打包多个版本

```bash
# 为不同版本打包
for VERSION in "2.3" "2.4" "2.5"; do
  rm -rf PlanCheck.app
  bash build_tools/final_build.sh
  hdiutil create -volname "PlanCheck" \
    -srcfolder PlanCheck.app \
    -ov \
    -format UDZO \
    PlanCheck_v${VERSION}.dmg
done
```

---

## 📝 技术细节

### final_build.sh 脚本内容

该脚本执行以下操作：

1. **设置环境变量**
   - SDK 路径
   - 输出目录

2. **编译 Swift 源文件**
   - 使用 swiftc 编译器
   - 链接 SwiftUI 框架
   - 优化代码大小

3. **生成应用结构**
   - Info.plist
   - PkgInfo
   - 资源文件

4. **代码签名**
   - Ad-hoc 签名
   - 适合本地分发

5. **自动启动应用**
   - 编译成功后自动打开

### 支持的架构

- ✅ arm64 (Apple Silicon M1/M2/M3)
- ❌ x86_64 (Intel Mac) - 暂不支持

### 系统要求

- macOS 15.0+
- Xcode Command Line Tools (可选，用于获取 SDK)

---

## 🔗 相关文档

- [构建工具集说明](README.md)
- [快速开始指南](QUICK_START.md)
- [项目主 README](../README.md)

---

**最后更新**: 2026-03-24  
**验证状态**: ✅ 所有命令已在实际环境中验证通过  
**维护者**: AI Assistant for PlanCheck Project
