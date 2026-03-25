import SwiftUI

struct TaskRowView: View, Equatable {
    let task: TaskItem
    let isEditingMode: Bool
    let isSelected: Bool
    let onToggleSelection: () -> Void
    let onStart: () -> Void
    let onComplete: (Date, OvertimeAction) -> Void
    let onReopen: () -> Void
    let onToggleImportant: () -> Void
    let onToggleMyDay: () -> Void
    let onDelete: () -> Void
    let onEdit: (String, Int, TaskContext, String?, Bool) -> Void
    let onConfirmSingleDelete: (() -> Void)?
    let sunIconHelpText: String?
    let onCopy: (() -> Void)?
    let onTogglePinned: (() -> Void)?
    
    // MARK: - Equatable Conformance
    static func == (lhs: TaskRowView, rhs: TaskRowView) -> Bool {
        lhs.task.id == rhs.task.id &&
        lhs.task.title == rhs.task.title &&
        lhs.task.estimatedMinutes == rhs.task.estimatedMinutes &&
        lhs.task.context == rhs.task.context &&
        lhs.task.notes == rhs.task.notes &&
        lhs.task.status == rhs.task.status &&
        lhs.task.isImportant == rhs.task.isImportant &&
        lhs.task.isInMyDay == rhs.task.isInMyDay &&
        lhs.task.isPinned == rhs.task.isPinned
    }
    @State private var showingCheckSheet = false
    @State private var showingEditSheet = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            leadingStatusButton

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(task.title)
                        .strikethrough(task.status == .completed || task.status == .abandoned)
                    if task.isImportant {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .help("重要任务")
                    }
                }

                HStack(spacing: 8) {
                    statusCapsule
                    contextCapsule
                    priorityCapsule

                    if task.carryOverCount > 0 {
                        Text("转入\(task.carryOverCount)次")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    Text("创建 \(timeFormatter.string(from: task.createdAt))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Text("预计：\(task.estimatedMinutes) 分钟")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let score = task.priorityScore {
                    Text("优先级分数：\(score.formatted(.number.precision(.fractionLength(2)))) · 到账\(task.expectedDaysToCash ?? 0)天 · 金额\(task.expectedCashInRMB ?? 0)元")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                if let notes = task.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                if let actual = task.actualMinutes {
                    Text("实际：\(actual) 分钟 (\(diffString(actual)))")
                        .font(.caption)
                        .foregroundColor(diffColor(actual))
                } else if task.status == .completed {
                    Text("已完成（未记录实际时长）")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if task.status == .inProgress {
                    Text("任务进行中")
                        .font(.caption)
                        .foregroundColor(.orange)
                    if let startedAt = task.startedAt {
                        Text("开始于 \(detailTimeFormatter.string(from: startedAt))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } else if task.status == .abandoned {
                    Text("任务已放弃")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 1) { [isEditingMode] in
                guard !isEditingMode, task.status.isPending else { return }
                showingEditSheet = true
            }
            .keyboardShortcut(.return, modifiers: [])
            .focused($isFocused)
            .onKeyPress(.space) {
                if isEditingMode {
                    onToggleSelection()
                    return .handled
                }
                return .ignored
            }

            Spacer(minLength: 8)

            if !isEditingMode {
                HStack(spacing: 8) {
                    // 新增：置顶按钮（在复制图标左侧）
                    if let onTogglePinned = onTogglePinned {
                        Button(action: onTogglePinned) {
                            Image(systemName: task.isPinned ? "pin.fill" : "pin")
                                .foregroundColor(task.isPinned ? .red : .secondary)
                        }
                        .buttonStyle(.plain)
                        .help(task.isPinned ? "取消置顶" : "置顶任务")
                    }

                    // 复制按钮
                    if let onCopy = onCopy {
                        Button(action: onCopy) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help("复制标题和备注")
                    }

                    Button(action: onToggleImportant) {
                        Image(systemName: task.isImportant ? "star.fill" : "star")
                            .foregroundColor(task.isImportant ? .yellow : .secondary)
                    }
                    .buttonStyle(.plain)
                    .help(task.isImportant ? "取消重要标记" : "标记为重要")

                    Button(action: onToggleMyDay) {
                        Image(systemName: task.isInMyDay ? "sun.max.fill" : "sun.max")
                            .foregroundColor(task.isInMyDay ? .orange : .secondary)
                    }
                    .buttonStyle(.plain)
                    .help(sunIconHelpText ?? (task.isInMyDay ? "从我的一天移除" : "加入我的一天"))

                    Button(primaryActionTitle) {
                        handlePrimaryAction()
                    }
                    .buttonStyle(.borderedProminent)

                    Button(action: {
                        if let confirm = onConfirmSingleDelete {
                            confirm()
                        } else {
                            onDelete()
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .help("删除任务")
                }
                // 优化：为按钮组添加右侧边距，避免与滚动条重叠
                .padding(.trailing, 4)
            }
        }
        // 优化：为整个任务行添加右侧安全边距，确保删除按钮不与滚动条重叠
        .padding(.trailing, 8)
        .contextMenu {
            if task.status == .notStarted {
                Button("开始任务", action: onStart)

                Menu("设置优先级") {
                    ForEach(PriorityLevel.allCases) { level in
                        Button(level.name) {
                            taskStore.setPriority(taskID: task.id, level: level)
                        }
                    }
                }

                Divider()

                Button("编辑任务") {
                    showingEditSheet = true
                }

                Button("删除任务", role: .destructive) {
                    onDelete()
                }
            } else if task.status == .inProgress {
                Button("暂停任务") {
                    onReopen()
                }

                Button("完成任务") {
                    onComplete(Date(), .keepInMyDay)
                }

                Menu("设置优先级") {
                    ForEach(PriorityLevel.allCases) { level in
                        Button(level.name) {
                            taskStore.setPriority(taskID: task.id, level: level)
                        }
                    }
                }

                Divider()

                Button("编辑任务") {
                    showingEditSheet = true
                }

                Button("删除任务", role: .destructive) {
                    onDelete()
                }
            } else if task.status == .completed {
                Button("重新打开") {
                    onReopen()
                }

                Menu("设置优先级") {
                    ForEach(PriorityLevel.allCases) { level in
                        Button(level.name) {
                            taskStore.setPriority(taskID: task.id, level: level)
                        }
                    }
                }

                Divider()

                Button("编辑任务") {
                    showingEditSheet = true
                }

                Button("删除任务", role: .destructive) {
                    onDelete()
                }
            } else if task.status == .abandoned {
                Button("重新打开") {
                    onReopen()
                }

                Button("彻底删除", role: .destructive) {
                    onDelete()
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditTaskView(
                taskToEdit: task,
                onSave: { title, minutes, context, notes, important in
                    onEdit(title, minutes, context, notes, important)
                },
                isPresented: $showingEditSheet
            )
            .environmentObject(taskStore)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        )
        .onTapGesture(count: 2) {
            guard task.status.isPending else { return }
            showingEditSheet = true
        }
    }

    // MARK: - Helper Properties

    private var primaryActionTitle: String {
        switch task.status {
        case .notStarted: return "开始"
        case .inProgress: return "完成"
        case .completed: return "完成"
        case .abandoned: return "完成"
        }
    }

    private func handlePrimaryAction() {
        switch task.status {
        case .notStarted:
            onStart()
        case .inProgress:
            onComplete(Date(), .keepInMyDay)
        case .completed, .abandoned:
            break
        }
    }

    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    private var detailTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    private func diffString(_ actual: Int) -> String {
        let diff = actual - task.estimatedMinutes
        if diff > 0 {
            return "+\(diff)"
        } else if diff < 0 {
            return "\(diff)"
        } else {
            return "±0"
        }
    }

    private func diffColor(_ actual: Int) -> Color {
        let diff = actual - task.estimatedMinutes
        if diff > 0 {
            return .red
        } else if diff < 0 {
            return .green
        } else {
            return .secondary
        }
    }

    @ViewBuilder
    private var leadingStatusButton: some View {
        if isEditingMode {
            // 编辑模式：显示复选框
            CheckboxView(isChecked: isSelected)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    onToggleSelection()
                }
        } else {
            // 普通模式：根据状态显示不同按钮
            switch task.status {
            case .notStarted:
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        onStart()
                    }
            case .inProgress:
                Button(action: {
                    onComplete(Date(), .keepInMyDay)
                }) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .background(Circle().fill(Color.orange).frame(width: 20, height: 20))
                .help("完成任务")
            case .completed:
                Button(action: onReopen) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .background(Circle().fill(Color.green).frame(width: 20, height: 20))
                .help("重新打开")
            case .abandoned:
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        onReopen()
                    }
            }
        }
    }

    @ViewBuilder
    private var statusCapsule: some View {
        Capsule()
            .fill(statusColor)
            .frame(height: 22)
            .overlay(
                HStack(spacing: 4) {
                    Image(systemName: statusIcon)
                    Text(statusText)
                }
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
            )
    }

    private var statusColor: Color {
        switch task.status {
        case .notStarted: return .gray
        case .inProgress: return .orange
        case .completed: return .green
        case .abandoned: return .secondary
        }
    }

    private var statusIcon: String {
        switch task.status {
        case .notStarted: return "circle"
        case .inProgress: return "play.fill"
        case .completed: return "checkmark.circle.fill"
        case .abandoned: return "slash.circle"
        }
    }

    private var statusText: String {
        switch task.status {
        case .notStarted: return "待处理"
        case .inProgress: return "进行中"
        case .completed: return "已完成"
        case .abandoned: return "已放弃"
        }
    }

    @ViewBuilder
    private var contextCapsule: some View {
        if !task.context.isEmpty {
            Capsule()
                .fill(Color.blue.opacity(0.2))
                .frame(height: 22)
                .overlay(
                    HStack(spacing: 4) {
                        Image(systemName: "briefcase.fill")
                        Text(task.context)
                    }
                    .font(.caption2)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                )
        }
    }

    @ViewBuilder
    private var priorityCapsule: some View {
        if let priority = task.priority {
            Capsule()
                .fill(priorityColor(priority))
                .frame(height: 22)
                .overlay(
                    HStack(spacing: 4) {
                        Image(systemName: "flag.fill")
                        Text(priority.name)
                    }
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                )
        }
    }

    private func priorityColor(_ priority: PriorityLevel) -> Color {
        switch priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}
