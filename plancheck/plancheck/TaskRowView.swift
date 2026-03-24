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
        lhs.isEditingMode == rhs.isEditingMode &&
        lhs.isSelected == rhs.isSelected &&
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
            }
        }
        .contextMenu {
            if task.status == .notStarted {
                Button("开始任务", action: onStart)
            } else if task.status == .inProgress {
                Button("完成任务") {
                    showingCheckSheet = true
                }
            } else {
                Button("重新开始", action: onReopen)
            }

            Button(task.isImportant ? "取消重要标记" : "标记为重要", action: onToggleImportant)
            Button(task.isInMyDay ? "从我的一天移除" : "加入我的一天", action: onToggleMyDay)
            if let onTogglePinned = onTogglePinned {
                Button(task.isPinned ? "取消置顶" : "置顶任务", action: onTogglePinned)
            }
        }
        .sheet(isPresented: $showingCheckSheet) {
            CheckTaskView(task: task, onComplete: onComplete)
        }
        .sheet(isPresented: $showingEditSheet) {
            EditTaskView(task: task, onSave: onEdit)
        }
    }

    private var leadingStatusButton: some View {
        Button(action: handleLeadingButtonTap) {
            Image(systemName: leadingSymbolName)
                .foregroundColor(leadingIconColor)
        }
        .buttonStyle(.plain)
    }

    private var statusCapsule: some View {
        Text(task.status.title)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(statusColor.opacity(0.15))
            .foregroundColor(statusColor)
            .clipShape(Capsule())
    }

    private var contextCapsule: some View {
        Text(task.context.title)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(contextColor(task.context).opacity(0.15))
            .foregroundColor(contextColor(task.context))
            .clipShape(Capsule())
    }

    private var priorityCapsule: some View {
        HStack(spacing: 4) {
            Image(systemName: priorityTierSymbol)
                .font(.caption2)
            Text("\(task.priorityTier) 级")
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(priorityColor.opacity(0.15))
        .foregroundColor(priorityColor)
        .clipShape(Capsule())
        .help(priorityTooltip)
    }
    
    private var priorityTierSymbol: String {
        switch task.priorityTier {
        case PriorityTier.a.rawValue:
            return "star.fill"
        case PriorityTier.b.rawValue:
            return "star.lefthalf.filled"
        default:
            return "circle"
        }
    }
    
    private var priorityTooltip: String {
        guard let score = task.priorityScore else {
            return "优先级：\(task.priorityTier)"
        }
        let reason = task.priorityReason ?? ""
        return "优先级 \(task.priorityTier) · 分数 \(String(format: "%.2f", score))\n\(reason)"
    }

    private var leadingSymbolName: String {
        if isEditingMode {
            return isSelected ? "checkmark.circle.fill" : "circle"
        }
        switch task.status {
        case .notStarted:
            return "circle"
        case .inProgress:
            return "play.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        case .abandoned:
            return "xmark.circle.fill"
        }
    }

    private var leadingIconColor: Color {
        if isEditingMode {
            return isSelected ? .blue : .gray
        }
        return statusColor
    }

    private var statusColor: Color {
        switch task.status {
        case .notStarted:
            return .gray
        case .inProgress:
            return .orange
        case .completed:
            return .green
        case .abandoned:
            return .secondary
        }
    }

    private var priorityColor: Color {
        switch task.priorityTier {
        case PriorityTier.a.rawValue:
            return .red
        case PriorityTier.b.rawValue:
            return .orange
        default:
            return .secondary
        }
    }

    private func handleLeadingButtonTap() {
        if isEditingMode {
            // 编辑模式：保持原有的选中/取消选中功能
            onToggleSelection()
            return
        }

        // 非编辑模式：在"待处理"和"进行中"之间切换状态
        switch task.status {
        case .notStarted:
            // 从"待处理"切换到"进行中"
            onStart()
        case .inProgress:
            // 从"进行中"切换回"待处理"
            // 注意：这里使用 onReopen 回调，但实际逻辑应该是 pauseTask
            // 需要在调用方（TodayView/AllTasksView）中区分
            onReopen()
        case .completed, .abandoned:
            // 其他状态不响应点击
            break
        }
    }

    private var primaryActionTitle: String {
        switch task.status {
        case .notStarted:
            return "开始"
        case .inProgress:
            return "完成"
        case .completed, .abandoned:
            return "重新开始"
        }
    }

    private func handlePrimaryAction() {
        switch task.status {
        case .notStarted:
            onStart()
        case .inProgress:
            showingCheckSheet = true
        case .completed, .abandoned:
            onReopen()
        }
    }

    private func diffString(_ actual: Int) -> String {
        let diff = actual - task.estimatedMinutes
        return diff >= 0 ? "+\(diff)" : "\(diff)"
    }

    private func diffColor(_ actual: Int) -> Color {
        let diff = actual - task.estimatedMinutes
        if diff > 0 { return .red }
        else if diff < 0 { return .green }
        else { return .secondary }
    }

    private func contextColor(_ context: TaskContext) -> Color {
        switch context {
        case .deepWork:
            return .blue
        case .fragmented:
            return .orange
        case .meeting:
            return .teal
        }
    }

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private let detailTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}
