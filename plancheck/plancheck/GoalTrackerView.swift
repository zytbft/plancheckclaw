import SwiftUI

// MARK: - 目标日期常量

private let wealthTargetDate = Calendar.current.date(from: DateComponents(year: 2046, month: 1, day: 1))!
private let healthTargetDate = Calendar.current.date(from: DateComponents(year: 2136, month: 3, day: 23))!

// MARK: - 主视图

struct GoalTrackerView: View {
    @EnvironmentObject private var taskStore: TaskStore
    @StateObject private var storage = GoalTrackerStorage()
    
    // 数据输入状态
    @State private var inputWealth = ""
    @State private var inputHealth = ""
    @State private var inputGrowth = ""
    @State private var inputDeepWork = ""
    @State private var inputWorkout = ""
    @State private var inputSleep = ""
    @State private var inputROI = ""
    
    // UI 状态
    @State private var showingSuccessToast = false
    @State private var currentQuote = InspirationalQuote.random
    
    // 今日任务
    private var todayTasks: [TaskItem] {
        let today = Date()
        return taskStore.tasks.filter {
            $0.isInMyDay && Calendar.current.isDate($0.createdAt, inSameDayAs: today)
        }
    }
    
    private var actionItems: [ActionItem] {
        todayTasks.map { ActionItem(task: $0) }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 标题
                headerSection
                
                // 倒计时卡片
                countdownSection
                
                // 进度仪表盘
                progressSection
                
                // 习惯追踪
                habitsSection
                
                // 今日行动
                actionsSection
                
                // 随机名言
                quoteSection
                
                // 数据输入
                inputSection
            }
            .padding()
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            // 初始化输入框
            refreshInputFields()
            // 刷新名言
            currentQuote = InspirationalQuote.random
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("🎯 151 岁 × 1 亿/年")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("人生目标追踪系统 | 成为中国的巴菲特和查理·芒格")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Countdown Section
    
    private var countdownSection: some View {
        HStack(spacing: 15) {
            CountdownCardView(
                targetDate: wealthTargetDate,
                title: "财务自由倒计时",
                icon: "💰",
                detail: "距离 2046 年年被动收入 1 亿元",
                color: .yellow
            )
            
            CountdownCardView(
                targetDate: healthTargetDate,
                title: "健康长寿倒计时",
                icon: "💪",
                detail: "距离 2136 年 151 岁生日",
                color: .green
            )
        }
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("📊 目标进度仪表盘")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ProgressItemView(
                    label: "财富目标进度",
                    percent: storage.data.wealthProgressPercent,
                    valueText: "\(storage.data.currentWealth.toLocaleString()) 元 / 1 亿元",
                    color: .purple
                )
                
                ProgressItemView(
                    label: "健康目标进度",
                    percent: storage.data.healthProgressPercent,
                    valueText: "综合健康评分：\(storage.data.currentHealth) / 100",
                    color: .green
                )
                
                ProgressItemView(
                    label: "年度成长进度",
                    percent: storage.data.growthProgressPercent,
                    valueText: "已完成研报：\(storage.data.currentGrowth) 份 / 20 份",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Habits Section
    
    private var habitsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("🔥 习惯追踪")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                HabitCardView(
                    icon: "📚",
                    title: "深度工作",
                    value: "\(storage.data.deepWorkDays)",
                    label: "连续天数",
                    color: LinearGradient(gradient: Gradient(colors: [.pink, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                
                HabitCardView(
                    icon: "🏃",
                    title: "本周运动",
                    value: "\(storage.data.workoutCount)/5",
                    label: "次",
                    color: LinearGradient(gradient: Gradient(colors: [.orange, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                
                HabitCardView(
                    icon: "😴",
                    title: "平均睡眠",
                    value: String(format: "%.1fh", storage.data.sleepHours),
                    label: "小时/天",
                    color: LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                
                HabitCardView(
                    icon: "📈",
                    title: "投资收益率",
                    value: String(format: "%.1f%%", storage.data.roiRate),
                    label: "年化",
                    color: LinearGradient(gradient: Gradient(colors: [.green, .teal]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("✅ 今日行动")
                .font(.title2)
                .fontWeight(.semibold)
            
            if actionItems.isEmpty {
                Text("今日暂无任务，去添加一些任务吧～")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(actionItems) { item in
                        ActionRowView(
                            item: item,
                            onToggle: toggleTaskCompletion
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Quote Section
    
    private var quoteSection: some View {
        VStack(spacing: 12) {
            Text("\"\(currentQuote.text)\"")
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text("— \(currentQuote.author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
    
    // MARK: - Input Section
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("⚙️ 更新今日数据")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                InputFieldView(label: "当前被动收入（元）", value: $inputWealth, placeholder: "例如：5000000")
                InputFieldView(label: "健康评分", value: $inputHealth, placeholder: "例如：75", isInteger: true)
                InputFieldView(label: "已完成研报数量", value: $inputGrowth, placeholder: "例如：8", isInteger: true)
                InputFieldView(label: "连续深度工作天数", value: $inputDeepWork, placeholder: "例如：15", isInteger: true)
                InputFieldView(label: "本周运动次数", value: $inputWorkout, placeholder: "例如：3", isInteger: true)
                InputFieldView(label: "平均睡眠时长（小时）", value: $inputSleep, placeholder: "例如：7.5")
                InputFieldView(label: "投资年化收益率（%）", value: $inputROI, placeholder: "例如：18")
            }
            
            Button(action: saveData) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("更新数据")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Helper Methods
    
    private func refreshInputFields() {
        inputWealth = "\(storage.data.currentWealth)"
        inputHealth = "\(storage.data.currentHealth)"
        inputGrowth = "\(storage.data.currentGrowth)"
        inputDeepWork = "\(storage.data.deepWorkDays)"
        inputWorkout = "\(storage.data.workoutCount)"
        inputSleep = String(storage.data.sleepHours)
        inputROI = String(storage.data.roiRate)
    }
    
    private func saveData() {
        let wealth = Int(inputWealth) ?? 0
        let health = Int(inputHealth) ?? 0
        let growth = Int(inputGrowth) ?? 0
        let deepWork = Int(inputDeepWork) ?? 0
        let workout = Int(inputWorkout) ?? 0
        let sleep = Double(inputSleep) ?? 0.0
        let roi = Double(inputROI) ?? 0.0
        
        storage.updateAll(
            wealth: wealth,
            health: health,
            growth: growth,
            deepWorkDays: deepWork,
            workoutCount: workout,
            sleepHours: sleep,
            roiRate: roi
        )
        
        showingSuccessToast = true
        
        // 刷新名言
        currentQuote = InspirationalQuote.random
    }
    
    private func toggleTaskCompletion(taskID: UUID) {
        guard let index = taskStore.tasks.firstIndex(where: { $0.id == taskID }) else { return }
        
        if taskStore.tasks[index].status == .completed {
            // 如果已完成，改为待开始
            var updatedTask = taskStore.tasks[index]
            updatedTask.status = TaskProgressStatus.notStarted
            updatedTask.endedAt = nil
            updatedTask.actualMinutes = nil
            updatedTask.updatedAt = Date()
            taskStore.tasks[index] = updatedTask
            let currentTasks = taskStore.tasks
            taskStore.tasks = currentTasks
            taskStore.persist()
        } else {
            // 如果未完成，标记为完成
            taskStore.completeTask(taskID: taskID, endedAt: Date(), overtimeAction: .complete)
        }
    }
}

// MARK: - Countdown Card View

struct CountdownCardView: View {
    let targetDate: Date
    let title: String
    let icon: String
    let detail: String
    let color: Color
    
    @State private var countdown: CountdownResult?
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(icon) \(title)")
                .font(.headline)
            
            if let countdown = countdown {
                Text(countdown.formattedDays)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                Text(countdown.formattedYMD)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("计算中...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .onAppear {
            countdown = calculateCountdown(to: targetDate)
        }
    }
    
    private func calculateCountdown(to targetDate: Date) -> CountdownResult {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month, .day], from: now, to: targetDate)
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        
        let totalDays = years * 365 + months * 30 + days
        
        return CountdownResult(totalDays: totalDays, years: years, months: months, days: days)
    }
}

// MARK: - Progress Item View

struct ProgressItemView: View {
    let label: String
    let percent: Double
    let valueText: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(String(format: "%.2f%%", percent))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                        .cornerRadius(6)
                    
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * CGFloat(min(100, max(0, percent))) / 100.0, height: 12)
                        .cornerRadius(6)
                        .animation(.easeInOut(duration: 0.8), value: percent)
                }
            }
            .frame(height: 12)
            
            Text(valueText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Habit Card View

struct HabitCardView: View {
    let icon: String
    let title: String
    let value: String
    let label: String
    let color: LinearGradient
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 32))
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption2)
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

// MARK: - Action Row View

struct ActionRowView: View {
    let item: ActionItem
    let onToggle: (UUID) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { onToggle(item.task.id) }) {
                ZStack {
                    Circle()
                        .strokeBorder(item.isCompleted ? Color.green : Color.accentColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            
            Text(item.text)
                .font(.body)
                .strikethrough(item.isCompleted, color: .secondary)
                .foregroundColor(item.isCompleted ? .secondary : .primary)
            
            Spacer()
            
            Text(item.time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Input Field View

struct InputFieldView: View {
    let label: String
    @Binding var value: String
    let placeholder: String
    var isInteger: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
            
            TextField(placeholder, text: $value)
                .textFieldStyle(.roundedBorder)
                .applyKeyboardType(isInteger: isInteger)
        }
    }
}

// MARK: - Helper Extension

extension View {
    func applyKeyboardType(isInteger: Bool) -> some View {
        // SwiftUI for macOS 不支持直接设置键盘类型
        // 这里返回原始视图
        return self
    }
}

// MARK: - Preview

#Preview {
    GoalTrackerView()
        .environmentObject(TaskStore())
}
