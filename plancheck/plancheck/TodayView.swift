import AppKit
import SwiftUI

enum TodayTaskFilter: String, CaseIterable, Identifiable {
    case all, pending, inProgress, completed, important
    var id: String { rawValue }
    var title: String {
        switch self {
        case .all: return "全部"
        case .pending: return "待处理"
        case .inProgress: return "进行中"
        case .completed: return "已完成"
        case .important: return "重要"
        }
    }
}

struct TodayView: View {
    @EnvironmentObject private var taskStore: TaskStore
    @EnvironmentObject private var searchState: SearchState
    @State private var taskFilter: TodayTaskFilter = .all
    @State private var showingBulkInput = false
    @State private var isEditingMode = false
    @State private var selectedTaskIDs: Set<UUID> = []
    @State private var lastSelectedTaskID: UUID?  // 记录上次选中的任务，用于 Shift+ 点击
    @State private var showingDeleteConfirmation = false
    @State private var lastDeletedTasks: [DeletedTask] = []
    @State private var showingUndoToast = false
    @State private var undoActionType: UndoActionType = .delete
    @State private var toastCountdown = 10
    @State private var toastTimer: Timer?
    @State private var taskToDeleteID: UUID?  // 单个任务删除时记录 ID
    @State private var showingRemoveFromMyDayConfirmation = false  // 从今日任务移除确认对话框
    @State private var taskToRemoveFromMyDayID: UUID?  // 记录要移除的任务 ID
    @State private var showingBatchRemoveFromMyDayConfirmation = false  // 批量从今日任务移除确认对话框
    @State private var showingCopyToast = false  // 复制成功提示
    @State private var copiedTaskCount = 0  // 复制的任务数量
    @State private var showingPinToast = false  // 置顶成功提示
    @State private var pinnedTaskCount = 0  // 置顶的任务数量
    @State private var isDraggingToSelect = false  // 是否正在拖动选择
    @State private var dragStartIndex: Int?  // 拖动起始位置索引

    enum UndoActionType {
        case delete
    }

    private var todayTasks: [TaskItem] {
        taskStore.sortedTodayTasks(referenceDate: Date())
    }

    private var topPriorityTasks: [TaskItem] {
        taskStore.topPriorityTasksForToday(referenceDate: Date(), limit: 3)
    }

    private var filteredTodayTasks: [TaskItem] {
        // 先按筛选器分类
        let tasks: [TaskItem]
        switch taskFilter {
        case .all: tasks = todayTasks
        case .pending: tasks = todayTasks.filter { $0.status.isPending }
        case .inProgress: tasks = todayTasks.filter { $0.status == .inProgress }
        case .completed: tasks = todayTasks.filter { $0.status == .completed }
        case .important: tasks = todayTasks.filter { $0.isImportant }
        }
        
        // 应用全局搜索过滤
        if !searchState.searchText.isEmpty {
            return tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchState.searchText) ||
                (task.notes?.localizedCaseInsensitiveContains(searchState.searchText) ?? false)
            }
        }
        
        return tasks
    }
  
    private var canDelete: Bool {
        !selectedTaskIDs.isEmpty
    }

    private var totalPlannedMinutes: Int {
        todayTasks.reduce(0) { $0 + $1.estimatedMinutes }
    }

    private var totalActualMinutes: Int {
        todayTasks.filter { $0.status == .completed }.reduce(0) { $0 + ($1.actualMinutes ?? 0) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 固定区域：今日概览、Top 3、批量操作和筛选器
                fixedContent
                
                // 可滚动区域：任务列表
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        taskListSection
                    }
                }
            }
        }
        .navigationTitle("今日任务")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if !isEditingMode {
                    addTaskButton
                    batchOperationMenu
                }
            }
        }
        .alert("从今日任务移除", isPresented: $showingRemoveFromMyDayConfirmation) {
            Button("取消", role: .cancel) {}
            Button("移除", role: .destructive) {
                if let taskID = taskToRemoveFromMyDayID {
                    removeFromMyDayAndUpdateSort(taskID: taskID)
                }
            }
        } message: {
            Text("确定要将此任务从今日任务移除吗？移除后任务仍会保留在全部任务中，并移动到列表顶部。")
        }
        .alert("从今日任务移除所选任务", isPresented: $showingBatchRemoveFromMyDayConfirmation) {
            Button("取消", role: .cancel) {}
            Button("移除", role: .destructive) {
                performBatchRemoveFromMyDay()
            }
        } message: {
            Text("确定要将所选的 \(selectedTaskIDs.count) 个任务从今日任务移除吗？移除后任务仍会保留在全部任务中，并移动到列表顶部。")
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var fixedContent: some View {
        VStack(spacing: 12) {
            todayOverviewCard
            if taskFilter == .all {
                top3PriorityTasksCard
            }
            if isEditingMode {
                editingToolbar
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .background(Color(NSColor.windowBackgroundColor))
    }

    @ViewBuilder
    private var todayOverviewCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.orange)
                Text("今日概览")
                    .font(.headline)
                Spacer()
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("总计划：\(totalPlannedMinutes) 分钟")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("实际完成：\(totalActualMinutes) 分钟")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("完成率：\(completionRate)%")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(completionRateColor)
                    Text("共 \(todayTasks.count) 项")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(10)
            .background(Color.accentColor.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var top3PriorityTasksCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("优先级最高任务")
                    .font(.headline)
                Spacer()
            }

            ForEach(topPriorityTasks.prefix(3)) { task in
                HStack {
                    Circle()
                        .strokeBorder(task.status == .completed ? Color.green : Color.gray, lineWidth: 2)
                        .frame(width: 16, height: 16)
                    Text(task.title)
                        .font(.caption)
                        .strikethrough(task.status == .completed)
                        .lineLimit(1)
                    Spacer()
                    Text("\(task.estimatedMinutes)分钟")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 2)
            }
        }
        .padding(16)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var editingToolbar: some View {
        HStack(spacing: 12) {
            Text("已选择 \(selectedTaskIDs.count) 项")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Button(action: cancelSelection) {
                Text("取消")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)

            Button(action: toggleEditingMode) {
                Text("完成")
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    private var batchOperationMenu: some View {
        Menu {
            // 全选功能
            Button(action: selectAllTasks) {
                Label("全选", systemImage: "checkmark.circle")
            }
            .disabled(filteredTodayTasks.isEmpty)
            
            Divider()
            
            // 取消全选功能
            Button(action: deselectAllTasks) {
                Label("取消全选", systemImage: "circle")
            }
            .disabled(selectedTaskIDs.isEmpty)
            
            Divider()
            
            Button(action: confirmDelete) {
                Label("删除所选", systemImage: "trash")
            }
            .disabled(!canDelete)
            
            Button(action: confirmBatchRemoveFromMyDay) {
                Label("从今日任务移除", systemImage: "sun.slash")
            }
            .disabled(selectedTaskIDs.isEmpty)
            
            Divider()
            
            Button(action: copySelectedTasks) {
                Label("复制任务", systemImage: "doc.on.doc")
            }
            .disabled(selectedTaskIDs.isEmpty)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("批量操作").font(.caption).foregroundColor(.secondary)
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("操作").font(.title3).fontWeight(.bold)
                }
                .foregroundColor(.accentColor)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .menuStyle(.borderedButton)
    }

    private var addTaskButton: some View {
        Button(action: { showingBulkInput = true }) {
            VStack(alignment: .leading, spacing: 4) {
                Text("批量粘贴").font(.caption).foregroundColor(.secondary)
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("添加任务").font(.title3).fontWeight(.bold)
                }
                .foregroundColor(.accentColor)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.bordered)
    }

    @ViewBuilder
    private var taskListSection: some View {
        if filteredTodayTasks.isEmpty {
            emptyStateView
        } else {
            ForEach(Array(filteredTodayTasks.enumerated()), id: \.element.id) { index, task in
                let isSelected = selectedTaskIDs.contains(task.id)
                TaskRowView(
                    task: task,
                    isEditingMode: isEditingMode,
                    isSelected: isSelected,
                    onToggleSelection: { [taskID = task.id] in
                        self.toggleSelection(taskID: taskID, event: NSApp.currentEvent)
                    },
                    onStart: { taskStore.startTask(taskID: task.id) },
                    onComplete: { end, action in
                        taskStore.completeTask(taskID: task.id, endedAt: end, overtimeAction: action)
                    },
                    onReopen: { 
                        // 根据当前状态决定是重新打开还是暂停任务
                        if task.status == .inProgress {
                            taskStore.pauseTask(taskID: task.id)
                        } else {
                            taskStore.reopenTask(taskID: task.id)
                        }
                    },
                    onToggleImportant: { taskStore.toggleImportant(taskID: task.id) },
                    onToggleMyDay: { 
                        confirmRemoveFromMyDay(taskID: task.id)
                    },
                    onDelete: { confirmSingleDelete(taskID: task.id) },
                    onEdit: { title, minutes, context, notes, important in
                        taskStore.updateTask(
                            taskID: task.id, title: title, estimatedMinutes: minutes, context: context,
                            notes: notes, isImportant: important)
                    },
                    onConfirmSingleDelete: nil,
                    sunIconHelpText: "从今日任务移除",
                    onCopy: { copyTaskText(taskID: task.id) },
                    onTogglePinned: { taskStore.togglePinned(taskID: task.id) }
                )
                .id(task.id)  // 使用 id 修饰符优化视图复用
                // 添加拖动选择手势支持
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            handleDragSelect(at: index, startLocation: value.location)
                        }
                        .onEnded { _ in
                            isDraggingToSelect = false
                            dragStartIndex = nil
                        }
                )
            }
        }
    }

    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "sun.haze")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("今天还没有任务")
                .font(.title2)
                .fontWeight(.medium)

            Text("点击上方按钮添加任务，或等待午夜自动转入")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }

    // MARK: - Methods

    private func confirmSingleDelete(taskID: UUID) {
        self.taskToDeleteID = taskID
        self.showingDeleteConfirmation = true
    }

    private func confirmDelete() {
        guard !selectedTaskIDs.isEmpty else { return }
        showingDeleteConfirmation = true
    }

    private func performDelete() {
        guard !selectedTaskIDs.isEmpty else { return }
        let idsToDelete = Array(selectedTaskIDs)
        taskStore.deleteTasks(taskIDs: idsToDelete)
        selectedTaskIDs.removeAll()
        isEditingMode = false

        // 显示撤销 Toast
        lastDeletedTasks = idsToDelete.map { id in
            DeletedTask(id: id, timestamp: Date())
        }
        showingUndoToast = true
        startCountdown()
    }

    private func performUndo() {
        switch undoActionType {
        case .delete:
            let idsToRestore = lastDeletedTasks.map { $0.id }
            _ = taskStore.restoreTasks(deletedTaskIDs: idsToRestore)
            lastDeletedTasks.removeAll()
        }

        closeToast()
    }

    private func startCountdown() {
        toastCountdown = 10
        toastTimer?.invalidate()
        toastTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if toastCountdown > 1 {
                toastCountdown -= 1
            } else {
                closeToast()
            }
        }
    }

    private func closeToast() {
        toastTimer?.invalidate()
        toastTimer = nil
        withAnimation {
            showingUndoToast = false
        }
    }

    private func copySelectedTasks() {
        let tasksToCopy = filteredTodayTasks.filter { selectedTaskIDs.contains($0.id) }
        let textToCopy = tasksToCopy.map { "\($0.title)" }.joined(separator: "\n")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textToCopy, forType: .string)
        
        // 显示复制成功提示
        copiedTaskCount = tasksToCopy.count
        showingCopyToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showingCopyToast = false
            }
        }
    }

    private func copyTaskText(taskID: UUID) {
        guard let task = filteredTodayTasks.first(where: { $0.id == taskID }) else { return }
        let textToCopy = "\(task.title)\n\(task.notes ?? "")"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textToCopy, forType: .string)
        
        // 显示复制成功提示
        copiedTaskCount = 1
        showingCopyToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showingCopyToast = false
            }
        }
    }

    private func togglePinned(taskID: UUID) {
        taskStore.togglePinned(taskID: taskID)
    }

    private func removeFromMyDayAndUpdateSort(taskID: UUID) {
        taskStore.removeFromMyDay(taskID: taskID)
        // 更新任务的 createdAt，使其排序到列表顶部
        taskStore.updateTaskCreatedAt(taskID: taskID, to: Date())
    }

    private func performBatchRemoveFromMyDay() {
        let tasksToRemove = Array(selectedTaskIDs)
        for taskID in tasksToRemove {
            removeFromMyDayAndUpdateSort(taskID: taskID)
        }
        selectedTaskIDs.removeAll()
        isEditingMode = false
        
        // 显示成功提示
        copiedTaskCount = tasksToRemove.count
        showingCopyToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showingCopyToast = false
            }
        }
    }

    private func confirmRemoveFromMyDay(taskID: UUID) {
        self.taskToRemoveFromMyDayID = taskID
        self.showingRemoveFromMyDayConfirmation = true
    }

    private func confirmBatchRemoveFromMyDay() {
        showingBatchRemoveFromMyDayConfirmation = true
    }

    private func cancelSelection() {
        withAnimation {
            selectedTaskIDs.removeAll()
            isEditingMode = false
        }
    }

    private func toggleEditingMode() {
        withAnimation {
            isEditingMode.toggle()
            if !isEditingMode {
                selectedTaskIDs.removeAll()
            }
        }
    }

    /// 全选功能：选择所有当前筛选条件下的任务
    private func selectAllTasks() {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedTaskIDs = Set(filteredTodayTasks.map { $0.id })
            if let lastTask = filteredTodayTasks.last {
                lastSelectedTaskID = lastTask.id
            }
        }
    }
    
    /// 取消全选功能：清空所有选择并退出编辑模式
    private func deselectAllTasks() {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedTaskIDs.removeAll()
            lastSelectedTaskID = nil
            isEditingMode = false
        }
    }

    private func selectSingleTask(taskID: UUID) {
        withAnimation(.easeInOut(duration: 0.1)) {
            selectedTaskIDs = [taskID]
            lastSelectedTaskID = taskID
        }
    }

    private func toggleSelection(taskID: UUID, event: NSEvent?) {
        withAnimation(.easeInOut(duration: 0.15)) {
            // 检查是否按下 Shift 键（连选）
            if let event = event, event.modifierFlags.contains(.shift), let lastID = lastSelectedTaskID {
                selectRange(from: lastID, to: taskID)
                return
            }

            // 检查是否按下 Command 键（切换选择）
            if let event = event, event.modifierFlags.contains(.command) {
                if selectedTaskIDs.contains(taskID) {
                    selectedTaskIDs.remove(taskID)
                } else {
                    selectedTaskIDs.insert(taskID)
                }
                lastSelectedTaskID = taskID
                return
            }

            // 普通点击：在编辑模式下实现 Toggle 切换效果
            if isEditingMode {
                // 编辑模式：点击已选中的任务会取消选中
                if selectedTaskIDs.contains(taskID) {
                    selectedTaskIDs.remove(taskID)
                } else {
                    selectedTaskIDs.insert(taskID)
                }
                lastSelectedTaskID = taskID
            } else {
                // 非编辑模式：单选
                selectSingleTask(taskID: taskID)
            }
        }
    }

    private func selectRange(from startID: UUID, to endID: UUID) {
        // 优化：直接遍历一次数组，同时建立缓存和选择
        var foundStart = false
        var foundEnd = false
        var rangeStart: Int?
        var rangeEnd: Int?
        
        let currentTasks = filteredTodayTasks
        for (index, task) in currentTasks.enumerated() {
            if task.id == startID {
                foundStart = true
                rangeStart = index
            }
            if task.id == endID {
                foundEnd = true
                rangeEnd = index
            }
            if foundStart && foundEnd {
                break
            }
        }
        
        guard let start = rangeStart, let end = rangeEnd else { return }
        let range = min(start, end)...max(start, end)
        for i in range {
            selectedTaskIDs.insert(currentTasks[i].id)
        }
        lastSelectedTaskID = endID
    }

    private func handleDragSelect(at index: Int, startLocation: CGPoint) {
        guard index < filteredTodayTasks.count else { return }

        if dragStartIndex == nil {
            dragStartIndex = index
        }

        guard let startIndex = dragStartIndex else { return }

        isDraggingToSelect = true
        let range = min(startIndex, index)...max(startIndex, index)
        for i in range {
            if i < filteredTodayTasks.count {
                selectedTaskIDs.insert(filteredTodayTasks[i].id)
            }
        }
    }

    private var completionRate: Int {
        guard !todayTasks.isEmpty else { return 0 }
        let completed = todayTasks.filter { $0.status == .completed }.count
        return Int((Double(completed) / Double(todayTasks.count)) * 100)
    }

    private var completionRateColor: Color {
        if completionRate >= 80 {
            return .green
        } else if completionRate >= 50 {
            return .orange
        } else {
            return .red
        }
    }
}
