# plancheck

轻量级 macOS 时间管理应用，聚焦「计划时长 vs 实际时长」复盘，支持每日任务管理、状态流转、未完成任务处理与周报导出。

![plancheck app icon](./assets/icon/AppIcon-1024.png)

**开源协议**: [AGPL-3.0](LICENSE) - 保护您的工作成果，任何修改和衍生作品必须同样开源

## 核心功能

### 🧘 天人合一 (v2.8) ✨ **新增**
- **身心校准系统**：融合呼吸科学、神经科学与正念精髓
- **五阶段练习**：环境准备 → 三层呼吸法 → 身体扫描 → 开放式觉察 → 整合回归
- **实时计时器**：每个阶段独立计时，支持开始/停止控制
- **呼吸引导动画**：动态圆圈缩放，直观引导吸气（4 秒）和呼气（6 秒）节奏
- **详细指导**：每个阶段都有完整的练习说明和要点提示
- **使用指南**：完整的核心理念说明和大师级实践建议
- **练习时长**：完整练习 35-45 分钟，也支持快速练习（10-15 分钟）

### 🔤 全局字体缩放 (v2.9) ✨ **新增**
- **快捷键调节**：`Command + =` 放大、`Command + -` 缩小、`Command + 0` 重置
- **12 级精细调节**：从 10pt 到 32pt，每级 2pt 步进
- **自动记忆**：保存用户偏好，下次启动自动恢复
- **全应用统一**：所有文本等比缩放，保持视觉层次
- **智能上下文**：文本编辑时仍可缩放，不影响输入

### 🪟 窗口尺寸记忆 (v2.9) ✨ **新增**
- **自动保存**：关闭时记住窗口大小
- **启动恢复**：打开应用时恢复到上次的大小
- **平滑动画**：尺寸变化带有流畅过渡效果

### 📋 任务管理模块
#### 今日任务 (v1.0) **[MVP]**
- **批量添加任务**：支持粘贴多行文本快速创建任务，自动解析标题与预估时长
- **任务状态流转**：`待开始 → 进行中 → 已完成`，支持 `已放弃` 状态
- **明确开始操作**：任务行提供 `开始/完成/重新开始` 主按钮，右键菜单支持"开始任务"
- **自动计时完成**：记录开始时间与结束时间，自动计算实际用时并计算偏差（实际 - 预计）；**支持手动修正**，用户可在确认完成前调整实际用时数值
- **智能时长建议**：同类历史任务的中位数作为预计时长建议
- **多行备注**：新增/编辑任务支持多行备注（最多 2000 字），列表显示摘要
- **创建时间展示**：Today 显示 `HH:mm`，历史记录显示 `yyyy-MM-dd HH:mm`

#### 批量操作 (v1.3) **[MVP]**
- **批量选择**：进入编辑模式后可多选任务
- **批量删除**：支持删除多个任务，删除后进入回收站
- **批量放弃**：支持将多个待处理任务标记为已放弃
- **撤回功能**：删除/放弃操作后 10 秒内可一键撤回
- **Toast 提示**：操作后显示全局提示，带倒计时和撤回按钮

#### 全部任务 (v1.6) ✨ **新增**
- **查看所有任务**：按创建时间倒序显示所有未被永久删除的任务
- **一键添加到今日**：每个任务右侧显示"小太阳"图标（`sun.max.fill`），点击即可复制一份到今日任务
  - 图标位置：任务行最右侧，五角星图标之后
  - 悬停提示："添加到今日任务"
  - 功能说明：创建任务副本到今日列表，保留原任务不变，sourceTaskID 指向原始任务
- **完整批量操作**：支持与今日任务一致的批量选择、批量删除、批量放弃功能
- **状态筛选**：支持按全部/待处理/进行中/已完成/已放弃/重要进行筛选
- **鼠标多选增强**：支持单击选择、Shift+ 连续多选、Command+ 切换选择

#### 今日任务 (v2.0 优化) ✨ **新增**
- **小太阳图标功能优化**：在"今日任务"视图中，点击小太阳图标执行以下操作
  - 从"我的一天"移除该任务（调用 `removeFromMyDay`）
  - 自动更新任务的 `createdAt` 时间为当前时间
  - 在"全部任务"视图中，该任务会自动移动到列表顶部
  - 任务本身不被删除或标记为已放弃，仅改变显示位置

#### 鼠标多选增强 (v1.5) ✨ **新增**
- **单击选择**：点击任务即可选中
- **Shift + 点击**：连续多选（从上一个选中项到当前点击项之间的所有任务）
- **Command + 点击**：切换单个任务选中状态（类似 macOS Finder）
- **右键菜单**：支持快速选择和批量操作

#### 优先级系统 (v1.2)
- **智能优先级分析**：基于任务标题自动推断优先级（A/B/C 三级）
- **优先级评分模型**：综合预计金额、到账天数、成功率、杠杆分数、战略匹配度五维评分
- **优先级可视化**：任务卡片显示优先级徽章，支持按优先级排序
- **AI 增强**：支持调用 LLM（GLM-5/Ollama）优化优先级评估
- **审计日志**：记录每次优先级分析的完整决策链路

#### 任务情境 (v1.0) **[MVP]**
- **情境分类**：深度工作/碎片任务/会议三种情境
- **情境筛选**：可按情境过滤查看任务

### 🗑️ 数据安全模块 (v2.0) ✨ **新增**
- **删除确认对话框**: 单击删除图标时弹出二次确认
  - **对话框标题**: "删除任务"
  - **内容提示**: "确定要删除该任务吗？此操作可在回收站中撤销。"
  - **双按钮设计**: "取消"和"删除"，仅点击"删除"后执行删除逻辑
  - **智能识别**: 自动区分单个删除和批量删除场景，显示对应提示
  - **撤回保障**: 删除后仍通过 Toast 提供 10 秒撤回机会
- **批量操作增强**: 批量删除时也需二次确认，防止误操作
### 🗑️ 回收站模块 (v1.3)
- **查看已删除**：独立视图展示所有已删除任务，按删除时间倒序排列
- **恢复任务**：支持单个恢复被删除的任务到今日列表
- **批量撤回**：删除/放弃操作后 10 秒内可通过 Toast 一键撤回
- **永久删除**：支持从回收站永久删除单个任务
- **清空回收站**：一键清空所有已删除任务（需二次确认）
- **自动清理**：30 天前的删除记录自动清理

### ⏱️ 时间追踪模块
#### 超时处理 (v1.0) **[MVP]**
- **超时预警**：任务超出预计时长时弹出提示
- **三种处理策略**：
  - **仍完成**：直接标记完成，记录偏差
  - **拆分**：自动创建"拆分续做"子任务继承剩余时长
  - **延后**：自动创建明天任务继承剩余时长

#### 我的一天 (v1.0) **[MVP]**
- **每日重置**：每天自动清空"我的一天"
- **建议任务**：根据优先级和情境推荐最多 5 项任务
- **一键加入**：支持将任务加入/移出"我的一天"

### 🎯 目标管理模块
#### 重要任务 (v1.0) **[MVP]**
- **星标标记**：支持任务标记为重要
- **重要视图**：独立视图集中展示未完成重要任务
- **筛选过滤**：今日任务支持按重要状态筛选

### 📊 复盘报告模块
#### 晚间复盘 (v1.0) **[MVP]**
- **手动复盘**：记录能量状态（高/中/低）、偏差原因、明日改进
- **自动复盘**：晚间自动生成复盘摘要、工作日志、次日安排建议
- **AI 驱动**：支持调用 LLM 生成深度复盘内容
- **本地回退**：AI 不可用时使用规则引擎生成本地复盘

#### 每周报告 (v1.0) **[MVP]**
- **核心指标**：完成率、总投入时长、平均偏差
- **Top5 榜单**：最耗时任务排名
- **状态分布**：已完成/待开始/已放弃任务统计
- **周报导出**：支持 CSV/Markdown/JSON 格式导出

### 🔍 搜索与筛选模块 (v2.0) ✨ **新增**
- **全局搜索框**: 位于左侧菜单栏顶部，支持跨视图搜索
  - **搜索范围**: 今日任务、全部任务、历史记录等所有任务列表
  - **实时响应**: 输入时即时过滤匹配的标题和备注内容
  - **一键清空**: 搜索框内提供清空按钮
  - **键盘快捷键**: `Cmd+F` 快速聚焦到搜索框
- **状态筛选**: 今日任务支持按全部/待处理/进行中/已完成/已放弃/重要筛选
- **键盘快捷键**:
  - `1-4` - 快速切换筛选状态
  - `Space` - 开始/完成任务
  - `Cmd+Enter` - 快速完成选中任务
  - `Escape` - 关闭搜索框/取消编辑模式

### ☁️ 数据同步模块
#### iCloud 同步 (v1.0)
- **实时同步**：开启后自动同步任务和复盘数据到 iCloud
- **手动同步**：设置中提供立即同步入口
- **状态显示**：显示最近同步时间和同步状态

#### 文件夹备份 (v1.0)
- **自定义目录**：支持选择任意目录作为备份路径
- **自动备份**：启用后自动备份任务和复盘数据
- **状态显示**：显示备份目录和备份状态

### 🤖 自动化模块 (v1.2)
- **外部执行器**：支持配置 Webhook 在任务状态变更时触发外部服务
- **自动运行**：任务开始时自动调用配置的接口

### ⚙️ 设置模块
#### 大模型配置 (v1.0)
- **GLM-5 配置**：支持配置 API Key、模型名称、温度参数
- **Ollama 配置**：支持配置本地 Ollama 服务和模型
- **连接测试**：提供测试按钮验证配置有效性
- **回退机制**：AI 调用失败时自动降级到本地规则引擎

#### 自动化配置 (v1.2)
- **启用开关**：控制自动化功能启停
- **Webhook URL**：配置触发的目标地址
- **触发条件**：配置哪些状态变更需要触发

## 📚 文档索引

### 核心文档
- **[English README](README_EN.md)** - English version
- **[贡献指南](CONTRIBUTING.md)** - 参与项目贡献指南

### 技术文档（docs/）
- **[需求文档](docs/01-需求/)** - 产品需求说明书、设计文档
- **[设计文档](docs/02-设计/)** - 架构设计、开发指南
- **[实现报告](docs/03-实现报告/)** - 各版本功能实现报告（含 v2.9 字体缩放）
- **[构建指南](docs/04-构建指南/)** - 编译打包教程
- **[Git 相关](docs/06-Git/)** - Git 工作流与备份指南
- **[工作流与规范](docs/07-工作流与规范/)** - 开发流程、检查清单、MCP 工具使用
- **[反思与总结](docs/08-反思与总结/)** - 项目复盘、深度反思
- **[开源与许可](docs/09-开源与许可/)** - AGPL-3.0 协议解释、商业化报告

## 运行环境
- macOS 15.0+ (Apple Silicon)
- **Xcode 16.0+** (推荐通过 App Store 安装)
- Swift 5.10+

## 快速开始（使用 Xcode）⭐

### 方法一：Xcode IDE（推荐）
```bash
cd /Users/zyt/work/mycode/32plancheckCodexLingma

# 1. 用 Xcode 打开项目
open plancheck/plancheck.xcodeproj

# 2. 在 Xcode 中：
#    - 选择开发团队（需要 Apple ID）
#    - 按 Cmd+B 编译
#    - 按 Cmd+R 运行

# 3. 签名和运行
#    Xcode -> Product -> Archive -> Distribute App
```

### 方法二：xcodebuild 命令行
```bash
cd /Users/zyt/work/mycode/32plancheckCodexLingma

# 编译 Debug 版本
xcodebuild -project plancheck/plancheck.xcodeproj \
  -scheme plancheck \
  -configuration Debug \
  -derivedDataPath build \
  build

# 编译 Release 版本
xcodebuild -project plancheck/plancheck.xcodeproj \
  -scheme plancheck \
  -configuration Release \
  -derivedDataPath build \
  build

# 产物位置
# build/Build/Products/Debug/plancheck.app
# build/Build/Products/Release/plancheck.app
```

### 方法三：无 Xcode 命令行（高级用户）
```bash
cd /Users/zyt/work/mycode/32plancheckCodexLingma

# 1) 生成应用图标（可重复执行）
./scripts/generate_app_icon.sh

# 2) 编译 + 打包（推荐使用 final_build.sh）
./build_tools/final_build.sh
```

产物位置：
- App：`dist/plancheck.app`
- Zip：`dist/plancheck-macos-nosxcode.zip`

⚠️ **注意**：无 Xcode 方式构建的应用可能缺少完整的代码签名，导致无法打开。如果遇到"应用可能已损坏"的错误，请使用 Xcode 方式构建。

## 图标设计
- 设计语义：
  - 蓝绿渐变底色：专注与持续改进。
  - 白色任务卡片：计划清单。
  - 右下角时钟徽标：时间追踪与复盘。
- 图标资源：
  - 源图：`assets/icon/AppIcon-1024.png`
  - 图标集：`assets/icon/AppIcon.iconset/`
  - 应用图标：`assets/icon/AppIcon.icns`
- 生成脚本：
  - 绘制脚本：`scripts/generate_app_icon.swift`
  - 一键生成：`scripts/generate_app_icon.sh`

## 数据存储
- 任务数据：`~/Library/Application Support/plancheck/tasks.json`
- 复盘数据：`~/Library/Application Support/plancheck/daily_reviews.json`

## 项目结构（关键文件）

### 🏗️ 架构演进

#### v2.4 (2026-03) - 模块化重构 ✨ **最新**
- **TaskStore 模块化**: 将 1667 行的单一文件拆分为 7 个职责单一的模块
  - `TaskStore.swift` - 核心框架与初始化
  - `TaskStore+Tasks.swift` - 任务 CRUD 操作扩展
  - `TaskStore+Reviews.swift` - 复盘管理扩展
  - `TaskStore+DeletedTasks.swift` - 回收站管理扩展
  - `TaskStore+Sync.swift` - iCloud/文件夹同步扩展
  - `TaskStore+MidnightCarry.swift` - 午夜自动转入扩展
  - `TaskStoreProtocol.swift` - TaskStore 协议定义
- **访问控制优化**: `private → internal` 支持扩展访问，保持封装性
- **代码质量提升**: 移除重复方法，统一代码风格，编译验证通过
- **架构收益**:
  - ✅ 职责单一，易于理解和维护
  - ✅ 协议抽象，提高可测试性
  - ✅ 支持并行开发，降低合并冲突
  - ✅ 为未来功能扩展提供清晰边界

```text
32plancheckCodexLingma/
├── README.md
├── README_EN.md
├── CONTRIBUTING.md
├── LICENSE
├── plancheck/plancheck/
│   ├── plancheckApp.swift          # 应用入口
│   ├── ContentView.swift           # 主界面
│   ├── TodayView.swift             # 今日任务（含搜索）
│   ├── HistoryView.swift           # 历史记录（含搜索）
│   ├── ImportantView.swift         # 重要任务
│   ├── WeeklyReportView.swift      # 每周报告
│   ├── AddTaskView.swift           # 添加任务
│   ├── EditTaskView.swift          # 编辑任务
│   ├── CheckTaskView.swift         # 完成登记（超时预警优化）
│   ├── TaskRowView.swift           # 任务行组件
│   ├── TaskModel.swift             # 数据模型
│   ├── TaskStore.swift             # 数据存储管理
│   └── Utils/                      # 工具类
│       ├── Formatters.swift        # 格式化器
│       ├── PriorityColor.swift     # 颜色扩展
│       └── AppError.swift          # 错误处理
└── scripts/
    ├── generate_app_icon.swift
    └── generate_app_icon.sh
```

## 常用开发命令

### Xcode 方式（推荐）
```bash
# 打开项目
open plancheck/plancheck.xcodeproj

# 命令行编译（Debug）
xcodebuild -project plancheck/plancheck.xcodeproj -scheme plancheck -configuration Debug build

# 命令行编译（Release）
xcodebuild -project plancheck/plancheck.xcodeproj -scheme plancheck -configuration Release build
```

### 无 Xcode 方式
```bash
# 重新生成图标
./scripts/generate_app_icon.sh

# 重新构建（推荐）
./build_tools/final_build.sh

# 或快速构建
./build_tools/final_build.sh
```

## 故障排查

### 问题："无法打开应用程序，因为它可能已损坏或不完整"

**解决方案 1**：使用 Xcode 重新构建（推荐）
```bash
open plancheck/plancheck.xcodeproj
# 在 Xcode 中选择开发团队，然后 Product -> Run
```

**解决方案 2**：移除隔离属性（不推荐，仅用于测试）
```bash
xattr -cr dist/plancheck.app
```

**解决方案 3**：检查代码签名
```bash
codesign --verify --verbose dist/plancheck.app
```

### 问题：通知不触发
请在系统设置中确认本应用的通知权限。

## 说明
- 当前为本地单机版：无账号、无云同步。
- 推荐使用 Xcode 进行开发和构建，以获得完整的代码签名和调试体验。
- 项目已集成键盘快捷键和搜索功能，提升使用效率。
