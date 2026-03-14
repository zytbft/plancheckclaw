# PlanCheck - Intelligent Time Management for macOS

[![Platform](https://img.shields.io/badge/platform-macOS%2015.0+-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.10-orange)]()
[![License](https://img.shields.io/badge/license-AGPL--3.0-green)]()

> 🎯 Focus on "Planned vs Actual" time tracking, with AI-powered task prioritization and automated reviews.

**License**: [AGPL-3.0](LICENSE) - Protects your work. Any modifications must be open-sourced under the same license.

![PlanCheck App Icon](./assets/icon/AppIcon-1024.png)

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
git clone https://github.com/zytbft/plancheckclaw.git
cd plancheckclaw
./build_tools/final_build.sh
```

### Download Pre-built
Visit [Releases](https://github.com/zytbft/plancheckclaw/releases) for latest version

## 📁 Project Structure

```
plancheckclaw/
├── plancheck/plancheck/     # Main source code
│   ├── ContentView.swift    # Main UI
│   ├── TodayView.swift      # Today tasks
│   ├── AllTasksView.swift   # All tasks view
│   ├── TaskStore.swift      # Data layer
│   └── ...
├── assets/                   # Resources
├── scripts/                  # Utility scripts
├── build_tools/              # Build tools
└── docs/                     # Documentation
```

## 💻 Development

### Setup
1. Install Xcode 16.0+
2. Configure code signing
3. Open `plancheck/plancheck.xcodeproj`
4. Select development team
5. Cmd+B to build

### Architecture
- **SwiftUI** for modern declarative UI
- **MVVM pattern** for separation of concerns
- **Combine framework** for reactive data flow
- **UserDefaults** for local persistence
- **iCloud CloudKit** for optional sync

## 📊 Current Capabilities vs Future Roadmap

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

3. **Analytics**
   - Auto-generate daily/weekly reports
   - Auto-calculate completion rates
   - Auto-export in multiple formats

#### 👤 Human-Required Tasks (User Decision Needed)
1. **Task Creation**
   - Define what tasks to do
   - Estimate initial duration
   - Set task context and importance

2. **State Transitions**
   - Decide when to START a task
   - Decide when to COMPLETE a task
   - Decide to ABANDON a task

### 🚀 What PlanCheck Will Do in FUTURE (Agent 2.0)
1. **Automatic Task Capture**
   - Monitor emails/calendar for action items
   - Extract tasks from meeting notes
   - Parse chat messages (Slack/Feishu) for todos

2. **Intelligent Planning**
   - Schedule based on energy levels
   - Block deep work sessions automatically
   - Batch similar tasks together

3. **Proactive Execution**
   - Auto-start routine tasks
   - Complete simple tasks automatically
   - Delegate tasks to team members

## 💰 Monetization Strategy

### Free Tier (Open Source)
- ✅ All core task management features
- ✅ Local data storage
- ✅ Basic analytics
- ✅ Keyboard shortcuts

### Pro Tier ($9.99/month or $99/year)
- 🌟 AI Priority Engine (unlimited LLM calls)
- 🌟 Advanced analytics & insights
- 🌟 Custom themes & branding
- 🌟 Team collaboration features

### Enterprise Tier (Custom Pricing)
- 🏢 Self-hosted deployment
- 🏢 SSO & SAML integration
- 🏢 Admin dashboard
- 🏢 Custom integrations (Jira, Asana, etc.)

## 🗺️ Roadmap to Profitability

### Phase 1: Foundation (Q1 2026) ✓
- Core task management
- Time tracking automation
- GitHub open source launch

### Phase 2: Growth (Q2-Q3 2026)
- AI priority engine
- Pro tier launch
- First 100 paying users

### Phase 3: Scale (Q4 2026 - Q1 2027)
- Team collaboration
- Enterprise features
- 1,000+ paying users

### Phase 4: Platform (2027+)
- API ecosystem
- Third-party integrations
- Marketplace for templates

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
