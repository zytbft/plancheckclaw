# plancheckclaw

轻量级 macOS 时间管理应用，聚焦「计划时长 vs 实际时长」复盘，支持每日任务管理、状态流转、未完成任务处理与周报导出。

![plancheck app icon](./assets/icon/AppIcon-1024.png)

**开源协议**: [AGPL-3.0](LICENSE) - 保护您的工作成果，任何修改和衍生作品必须同样开源

## 核心功能

### 📋 智能任务管理
- **时间盒（Time Boxing）**: 计划时长 vs 实际时长对比分析
- **AI 优先级排序**: 五维评分模型智能推荐
- **场景感知**: 深度工作 / 碎片时间 / 会议模式
- **批量操作**: 多选、批量删除、批量放弃
- **智能排序**: 新任务自动插入到已启动任务之后

### 🤖 自动化与智能化
- **自动计时**: 任务开始/结束时间自动追踪
- **键盘快捷键**: Command+S 保存，Command+Enter 完成
- **午夜自动结转**: 未完成任务自动移到第二天
- **智能建议**: 基于历史数据的时长预测

### 📊 数据与洞察
- **偏差分析**: 计划 vs 实际用时差异可视化
- **周报导出**: 自动生成 CSV 报告
- **完成率统计**: 日/周/月多维度分析
- **趋势图表**: 时间使用效率可视化

## 🚀 快速开始

### 系统要求
- macOS 15.0 或更高版本
- Xcode 16.0+ (用于编译)

### 安装方式

#### 方式 1: 下载预编译版本
访问 [Releases](https://github.com/zytbft/plancheckclaw/releases) 下载最新版本

#### 方式 2: 自行编译
```bash
# 克隆仓库
git clone https://github.com/zytbft/plancheckclaw.git
cd plancheckclaw

# 打开项目
open plancheck/plancheck.xcodeproj

# 在 Xcode 中编译运行
# 选择你的开发团队
# 按 Cmd+R 运行
```

## 📁 项目结构

```
plancheckclaw/
├── plancheck/plancheck/     # 主要源代码
│   ├── ContentView.swift    # 主界面
│   ├── TodayView.swift      # 今日任务视图
│   ├── AllTasksView.swift   # 全部任务视图
│   ├── TaskStore.swift      # 数据存储
│   └── ...
├── assets/                   # 资源文件
├── scripts/                  # 工具脚本
├── build_tools/              # 构建工具
└── docs/                     # 文档
```

## 🎯 设计理念

PlanCheck 基于以下时间管理理念设计：

1. **计划与反思**: 通过「计划时长 vs 实际时长」的对比，培养时间感知能力
2. **情境工作**: 根据任务类型（深度/碎片/会议）智能调度
3. **持续改进**: 通过周报和数据分析，不断优化时间分配
4. **极简主义**: 专注核心功能，避免过度复杂化

## 💡 最佳实践

### 每日工作流
1. **早晨规划** (5 分钟)
   - 查看今日任务列表
   - 调整优先级
   - 估算每项任务时长

2. **执行任务**
   - 点击任务开始计时
   - 专注完成当前任务
   - 完成后记录实际用时

3. **晚上复盘** (5 分钟)
   - 回顾完成情况
   - 分析时间偏差原因
   - 未完成任务自动结转到明天

### 每周复盘
- 导出周报 CSV
- 分析时间分配模式
- 识别效率提升点
- 调整下周计划

## 🛠️ 开发指南

### 环境配置
1. 安装 Xcode 16.0+
2. 配置代码签名
3. 打开 `plancheck/plancheck.xcodeproj`
4. 选择开发团队
5. Cmd+B 编译

### 构建发布版本
```bash
# 使用构建脚本
./final_build.sh

# 或使用 Xcode
# Product → Archive → Distribute App
```

## 🤝 贡献

我们欢迎各种形式的贡献！详见 [贡献指南](CONTRIBUTING.md)

### 开发环境设置
```bash
# Fork 仓库
# Clone 到本地
git clone https://github.com/YOUR_USERNAME/plancheckclaw.git
cd plancheckclaw

# 打开项目
open plancheck/plancheck.xcodeproj

# 编译运行
# Xcode → Cmd+R
```

### 提交规范
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式调整
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建/工具/配置

## 📄 开源协议

本项目采用 **GNU Affero General Public License v3.0 (AGPL-3.0)** 开源协议

这意味着：
- ✅ 你可以将 PlanCheck 用于个人或商业目的
- ✅ 你可以修改源代码
- ✅ 你可以分发副本
- ⚠️ 但任何修改和衍生作品必须同样开源

需要商业授权？请联系我们获取双重许可选项。

## 🙏 致谢

- 使用 SwiftUI 构建，享受 macOS 原生体验
- 灵感来自 Getting Things Done (GTD) 方法论
- 感谢社区成员的反馈和贡献

---

**Made with ❤️ by PlanCheck Team**

[Website](https://plancheck.app) | [Twitter](https://twitter.com/plancheckapp) | [Discord](https://discord.gg/plancheck)
