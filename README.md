# plancheck

轻量级 macOS 时间管理应用，聚焦「计划时长 vs 实际时长」复盘，支持每日任务管理、状态流转、未完成任务处理与周报导出。

<p align="center">
    <picture>
        <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/zytbft/plancheckclaw/main/assets/icon/AppIcon-1024.png">
        <img src="https://raw.githubusercontent.com/zytbft/plancheckclaw/main/assets/icon/AppIcon-1024.png" alt="plancheck" width="200">
    </picture>
</p>

**开源协议**: [AGPL-3.0](LICENSE) - 保护您的工作成果，任何修改和衍生作品必须同样开源

## 核心功能

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

## 📝 版本历史

### v2.4.19 (当前开发版本) ✨ **最新**
- 🎯 **新建任务倒序排列**: 紧挨着已开始任务下面，待处理任务内部新任务优先
- 📊 **排序优化**: 待处理任务按创建时间降序，其他状态保持升序
- 📝 **修改文件**: TaskPriorityService.swift (+6 行)

### v2.4.18 (当前开发版本)
- ⌨️ **编辑任务快捷键支持**: Command+Enter 或 Command+S 保存
- 🔧 **全局快捷键组件**: 新建 KeyboardShortcutsView 可复用组件
- 📝 **修改文件**: KeyboardShortcutsView.swift (新建), EditTaskView.swift, AddTaskView.swift

### v2.4.17 (当前开发版本)
- ⌨️ **Command+S 快捷键实现**: 使用 NSEvent 监听全局键盘事件
- 🔧 **快捷键优化**: 确保 Command+S 在任何情况下都能正常工作
- 📝 **修改文件**: AddTaskView.swift (+30 行)

### v2.4.15 (当前开发版本)
- ⌨️ **新建任务快捷键支持**: Command+Enter 或 Command+S 保存
- 🎯 **新建任务智能排序**: 自动插入到置顶和已开始任务后面，方便执行
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.15_NEW_TASK_SHORTCUT_SORT.md

### v2.4.14 (当前开发版本)
- 🎨 **筛选器固定不滚动优化**:
  - 今日任务视图：筛选器、批量操作、今日概览固定在顶部，只有任务列表滚动
  - 全部任务视图：筛选器、批量操作固定在顶部，只有任务列表滚动
  - 使用 VStack + ScrollView 替代 List 实现固定区域
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.14_FIXED_FILTER_SCROLL.md

### v2.4.13 (当前开发版本)
- 🎨 **全部任务视图批量操作样式统一**:
  - 去掉"筛选"和"状态"文字标签
  - 批量操作按钮和筛选器放在同一行
  - 样式与今日任务视图完全一致
  - 所有现有功能保持不变
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.13_ALLTASKS_BATCH_STYLE.md

### v2.4.12 (当前开发版本)
- 🎨 **优化今日任务视图批量操作按钮布局**:
  - 删除"今日概览"区域的批量操作菜单，避免与筛选器行重复
  - 恢复"批量粘贴"卡片在非编辑模式下的显示
  - 编辑模式下只显示筛选器行的批量操作按钮
  - 非编辑模式下显示"批量粘贴"卡片用于快速添加任务
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.12_RESTORE_BULK_PASTE_CARD.md

### v2.4.11 (当前开发版本)
- 🗑️ **删除今日概览区域重复按钮**:
  - 删除"今日概览"Section 内在编辑模式下的批量操作菜单
  - 避免与筛选器行的批量操作按钮重复
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.11_REMOVE_OVERVIEW_BUTTON.md

### v2.4.10 (当前开发版本)
- 🗑️ **删除编辑模式右上角重复按钮**:
  - 确认右上角工具栏无重复的批量操作按钮
  - 筛选器行已有完整的批量操作按钮组合
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.10_REMOVE_DUPLICATE_BUTTON.md

### v2.4.9 (当前开发版本)
- 🎨 **编辑模式批量操作按钮优化**:
  - 编辑模式下筛选器行显示 `[批量操作▼] [完成批量操作]`
  - 非编辑模式显示 `[批量操作] [筛选器]`
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.9_EDIT_MODE_LAYOUT.md

### v2.4.8 (当前开发版本)
- 🎨 **批量操作移至筛选器行**:
  - "批量操作"按钮放在筛选器行左侧
  - 布局：`[批量操作] [全部 待处理 进行中 已完成 已放弃 重要]`
  - 删除右上角工具栏的"批量操作"和"全部"按钮
- 📝 **更新文档**: ALLTASKS_IMPLEMENTATION.md, V2.4.8_BATCH_BUTTON_FILTER_ROW.md

### v2.4.1 (当前开发版本)
- 🐛 **修复午夜自动转入功能**:
  - 增强日志输出，添加详细的执行跟踪信息
  - 记录策略检查、任务查找、转入执行等关键步骤
  - 便于调试和验证定时器是否正常工作
- ✅ **修正说明文字**: 去掉"自动/手动"中的"/手动"
- 📝 **更新文档**: V2.3_MIDNIGHT_AUTO_CARRY_FEATURE.md, ALLTASKS_IMPLEMENTATION.md

### v2.4 (当前开发版本)
- 🏗️ **TaskStore 模块化重构**: 将 1667 行的单一文件拆分为 7 个职责单一的模块
  - `TaskStore.swift` - 核心框架与初始化
  - `TaskStore+Tasks.swift` - 任务增删改查操作
  - `TaskStore+Reviews.swift` - 复盘数据管理
  - `TaskStore+DeletedTasks.swift` - 回收站逻辑
  - `TaskStore+Sync.swift` - iCloud 和文件夹同步
  - `TaskStore+MidnightCarry.swift` - 午夜自动转入
  - `TaskStoreProtocol.swift` - 协议定义公共接口
- ✅ **访问控制优化**: 调整私有成员为 `internal`，支持扩展访问
- ✅ **代码质量提升**: 移除重复方法，统一代码风格
- 🎯 **架构收益**:
  - 职责单一，易于理解和维护
  - 协议抽象，提高可测试性
  - 支持并行开发，降低合并冲突
  - 为未来功能扩展提供清晰边界
- 📦 **编译验证**: 成功构建 PlanCheck.app

### v1.6 (当前开发版本)
- 📋 **全部任务视图**：新增"全部任务"菜单项，位于"今日任务"下方
- ☀️ **一键添加到今日**：每个任务右侧显示"小太阳"图标（`sun.max.fill`），点击即可复制任务到今日列表
  - 图标位置：任务行最右侧，五角星图标之后
  - 悬停提示："添加到今日任务"
  - sourceTaskID 追踪原始任务
- 🔍 **完整筛选功能**：支持按状态筛选所有历史任务
- 🖱️ **批量操作增强**：全部任务支持与今日任务一致的批量选择、删除、放弃功能
- ⚡ **鼠标多选支持**：单击选择、Shift+ 连续多选、Command+ 切换选择
- 🎨 **右键菜单优化**：任务卡片右键菜单支持快速选择和批量操作

### v1.5 (当前开发版本)
- 🖱️ **鼠标多选增强**：支持单击选择、Shift+ 点击连续多选、Command+ 点击切换选择
- 🎯 **右键菜单优化**：任务卡片右键菜单支持快速选择和批量操作
- ⚡ **交互体验提升**：与 macOS Finder 保持一致的多选交互逻辑

### v1.4 (当前开发版本)
- 🔄 **任务排序优化**：未完成的任务（待开始、进行中）始终排在已完成任务之前，已完成任务自动置于列表末尾
- ✏️ **手动修正时长**：完成登记时支持手动修改实际用时，默认显示系统自动计算结果，允许用户调整后提交
- ⏱️ **超时处理优化**：手动修正模式下清晰显示自动计算值与修改值的对比

### v1.3 (当前开发版本)
- 🗑️ **回收站功能**：新增完整的回收站模块，支持逻辑删除、任务恢复、永久删除
- ↩️ **撤回功能**：删除/放弃操作后 10 秒内可通过全局 Toast 一键撤回，带倒计时提示
- 🧹 **清空回收站**：支持批量清空已删除任务（二次确认保护）
- ⏱️ **Toast 优化**：操作提示支持动态倒计时显示和自动关闭

### v1.2 (当前开发版本)
- 🎯 **优先级系统**：新增智能优先级分析、五维评分模型、AI 增强评估
- 🤖 **任务自动化**：支持外部执行器 Webhook 集成
- 📊 **审计日志**：记录优先级分析决策链路

### v1.1
- 🔍 **搜索功能**：今日任务和历史记录支持实时搜索
- ⌨️ **键盘快捷键增强**：
  - `Cmd+F` - 打开搜索框
  - `1-4` - 快速切换筛选状态（待开始/进行中/已完成/已放弃）
  - `Space` - 开始/完成任务（非编辑模式）
  - `Cmd+Enter` - 快速完成选中任务
  - `Escape` - 关闭搜索框/取消编辑模式
- 🎨 **代码质量提升**：
  - 统一的格式化器工具类
  - 优先级/情境/状态颜色扩展
  - 完善的错误处理机制
- ⚠️ **超时预警优化**：更清晰的超时提示和处理选项说明

### v1.0 (MVP)
- ✅ 任务管理核心功能（增删改查、状态流转、批量操作）
- ✅ 时间追踪（自动计时、超时处理、偏差计算）
- ✅ 我的一天与重要任务
- ✅ 晚间复盘与每周报告
- ✅ iCloud 同步与文件夹备份
- ✅ 大模型配置（GLM-5/Ollama）

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
