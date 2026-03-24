# PlanCheck - Intelligent Time Management for macOS

[![Platform](https://img.shields.io/badge/platform-macOS%2015.0+-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.10-orange)]()
[![License](https://img.shields.io/badge/license-AGPL--3.0-green)]()

> 🎯 Focus on "Planned vs Actual" time tracking, with AI-powered task prioritization and automated reviews.

**License**: [AGPL-3.0](LICENSE) - Protects your work. Any modifications must be open-sourced under the same license.

<p align="center">
    <picture>
        <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/zytbft/plancheckclaw/main/assets/icon/AppIcon-1024.png">
        <img src="https://raw.githubusercontent.com/zytbft/plancheckclaw/main/assets/icon/AppIcon-1024.png" alt="PlanCheck" width="200">
    </picture>
</p>

## ✨ Key Features

### 📋 Smart Task Management
- **Time Boxing**: Plan duration vs actual tracking with deviation analysis
- **AI Prioritization**: 5-dimensional scoring model (amount, days-to-cash, success rate, leverage, strategic fit)
- **Context-Aware**: Deep work / Fragment tasks / Meetings
- **Bulk Operations**: Multi-select, bulk delete, bulk abandon with undo
- **Smart Sorting**: New tasks auto-insert after started tasks, before pending tasks

### 🤖 Automation & Intelligence
- **Auto Timer**: Track start/end times automatically
- **Keyboard Shortcuts**: Command+S to save, Command+Enter to complete
- **Midnight Carry-Over**: Unfinished tasks auto-move to next day
- **Intelligent Suggestions**: Time estimates, priority scores, top 3 must-do tasks

### 📊 Analytics & Reviews
- **Daily Reviews**: Energy tracking, deviation analysis, improvement plans
- **Weekly Reports**: Completion rate, top 5 time-consuming tasks, status distribution
- **Export**: CSV/Markdown/JSON formats

### 🔒 Data Security
- **Local First**: No cloud, no account required
- **iCloud Sync**: Optional end-to-end encrypted sync
- **Folder Backup**: Custom backup directory support
- **Trash & Recovery**: 30-day auto-cleanup with recovery option

## 🚀 Quick Start

### Prerequisites
- macOS 15.0+ (Apple Silicon recommended)
- Xcode 16.0+

### Build from Source
```bash
git clone https://github.com/YOUR_USERNAME/plancheck.git
cd plancheck
./build_tools/final_build.sh
```

### Run the App
```bash
open PlanCheck.app
```

## 🏗️ Architecture Highlights

### Modular Design (v2.4)
- **TaskStore Protocol**: Clean architecture with protocol-oriented programming
- **7 Modules**: Split 1667-line monolith into focused extensions
  - `TaskStore.swift` - Core framework & initialization
  - `TaskStore+Tasks.swift` - Task CRUD operations
  - `TaskStore+Reviews.swift` - Review management
  - `TaskStore+DeletedTasks.swift` - Trash logic
  - `TaskStore+Sync.swift` - iCloud & folder sync
  - `TaskStore+MidnightCarry.swift` - Auto carry-over
  - `TaskStoreProtocol.swift` - Protocol definition

### AI Integration
- **LLM Support**: GLM-5 / Ollama local models
- **Priority Inference**: Task title analysis with audit trail
- **Fallback**: Rule-based engine when AI unavailable

## 📊 Current Capabilities vs Future Roadmap

### ✅ Latest: v2.4.20 - Incomplete Task Carry-Over Strategy Optimization
- 🎯 **Smart Task Carry-Over**:
  - Original tasks automatically marked as "Abandoned" after carrying over to Today, avoiding duplicates in All Tasks view
  - Tracks cumulative carry-over count for each task, stops auto-carry when reaching limit
  - Optimized All Tasks filters: "All" shows only active tasks, "Abandoned" displays carry-over history
  - Detailed logging for debugging and verification
- 📝 **Modified Files**: TaskStore+Tasks.swift (+6 lines), AllTasksView.swift (+6 lines)
- 📄 **New Documentation**: V2.4.20_CARRY_OVER_STRATEGY_OPTIMIZATION.md

### ✅ What PlanCheck Can Do NOW

#### 🤖 Agent-Automatable Tasks (No Human Intervention)
1. **Time Tracking**
   - Auto-start timer when task begins
   - Auto-calculate actual duration
   - Auto-detect overtime and suggest actions

2. **Task Management**
   - Auto-sort by priority score
   - Auto-insert new tasks at optimal position
   - Auto-carry unfinished tasks to next day (midnight)
   - Auto-suggest estimated duration based on history

3. **Data Analysis**
   - Auto-generate daily review templates
   - Auto-calculate weekly statistics
   - Auto-export reports in multiple formats

4. **Intelligent Suggestions**
   - Suggest task priority (A/B/C tier)
   - Suggest time estimates from historical median
   - Suggest top 3 must-do tasks for today

#### 👤 Human-Required Tasks (User Decision Needed)
1. **Task Creation**
   - Define what tasks to do
   - Estimate initial duration (can accept AI suggestion)
   - Set task context and importance

2. **State Transitions**
   - Decide when to START a task
   - Decide when to COMPLETE a task
   - Decide to ABANDON a task

3. **Review & Reflection**
   - Provide energy level (high/medium/low)
   - Analyze deviation reasons
   - Plan improvements for tomorrow

4. **Priority Override**
   - Accept or reject AI priority suggestions
   - Manually mark tasks as important
   - Pin critical tasks to top

### 🚀 What PlanCheck Will Do in FUTURE (Agent 2.0)

#### 🎯 Full Agent Mode (PlanCheckClaw)
1. **Automatic Task Capture**
   - Monitor emails/calendar for action items
   - Extract tasks from meeting notes
   - Parse chat messages (Slack/Feishu) for todos

2. **Intelligent Planning**
   - Auto-schedule tasks based on energy patterns
   - Auto-block calendar for deep work sessions
   - Auto-negotiate deadlines with stakeholders

3. **Proactive Execution**
   - Start routine tasks automatically (e.g., daily standup prep)
   - Batch similar tasks together
   - Auto-delegate tasks to team members

4. **Learning & Adaptation**
   - Learn from user behavior patterns
   - Improve time estimates over time
   - Predict task blockers and risks

## 💰 Monetization Strategy

### Free Tier (Open Source)
- ✅ All core task management features
- ✅ Local data storage
- ✅ Basic analytics
- ✅ Keyboard shortcuts
- ✅ Bulk operations

### Pro Tier ($9.99/month or $99/year)
- 🌟 AI Priority Engine (unlimited LLM calls)
- 🌟 Advanced analytics & insights
- 🌟 Custom themes & branding
- 🌟 Priority support
- 🌟 Team collaboration features

### Enterprise Tier (Custom Pricing)
- 🏢 Self-hosted deployment
- 🏢 SSO & SAML integration
- 🏢 Admin dashboard
- 🏢 Audit logs & compliance
- 🏢 Custom integrations (Jira, Asana, etc.)

## 🛣️ Roadmap to Profitability

### Phase 1: Portfolio Showcase (Q2 2026)
- [x] MVP with core features
- [x] Clean modular architecture
- [ ] GitHub stars > 100
- [ ] Case study blog posts
- [ ] Conference talks submissions

### Phase 2: Community Building (Q3 2026)
- [ ] Launch landing page
- [ ] Collect user feedback
- [ ] Build contributor community
- [ ] Add plugin system
- [ ] Create tutorial videos

### Phase 3: Freemium Launch (Q4 2026)
- [ ] Implement licensing system
- [ ] Add Pro features
- [ ] Set up payment processing
- [ ] Marketing campaign
- [ ] First 100 paying users

### Phase 4: Scale & Expand (2027)
- [ ] iOS/iPad version
- [ ] Team features
- [ ] API for 3rd party integrations
- [ ] Marketplace for templates
- [ ] Partnership with productivity tools

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Run tests (if applicable)
5. Submit a pull request

## 📄 License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)** - see the [LICENSE](LICENSE) file for details.

### What This Means:

✅ **You can**:
- Use PlanCheck for personal or commercial purposes
- Modify the source code
- Distribute copies

⚠️ **But you must**:
- Open-source any modifications under AGPL-3.0
- Provide source code to users (even for SaaS)
- Credit the original authors

💼 **Need a commercial license**? Contact us for dual licensing options.

## 🙏 Acknowledgments

- Built with SwiftUI for macOS
- Inspired by Getting Things Done (GTD) methodology
- Community feedback and contributions

---

**Made with ❤️ by PlanCheck Team**

[Website](https://plancheck.app) | [Twitter](https://twitter.com/plancheckapp) | [Discord](https://discord.gg/plancheck)
