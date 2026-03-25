import Foundation

// MARK: - Task Update Operations

extension TaskStore {
    
    // MARK: - Update Tasks
    
    /// 更新任务信息
    func updateTask(
        taskID: UUID,
        title: String,
        estimatedMinutes: Int,
        context: TaskContext,
        notes: String?,
        isImportant: Bool
    ) {
        let trimmed = TaskItem.normalizedTitle(title)
        guard !trimmed.isEmpty, TaskItem.isValidMinutes(estimatedMinutes) else { return }
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].status.isPending else { return }
        
        // 创建新实例以触发 SwiftUI 视图刷新
        var updatedTask = tasks[index]
        updatedTask.title = trimmed
        updatedTask.estimatedMinutes = estimatedMinutes
        updatedTask.context = context
        updatedTask.notes = TaskItem.normalizedNotes(notes)
        updatedTask.isImportant = isImportant
        updatedTask.updatedAt = Date()
        
        // 替换整个任务对象，触发 @Published 通知
        tasks[index] = updatedTask
        persist()
    }
    
    /// 切换任务的重要状态
    func toggleImportant(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        // 创建新实例以触发 SwiftUI 视图刷新
        var updatedTask = tasks[index]
        updatedTask.isImportant.toggle()
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }

    /// 切换任务的置顶状态
    func togglePinned(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        // 创建新实例以触发 SwiftUI 视图刷新
        var updatedTask = tasks[index]
        updatedTask.isPinned.toggle()
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }

    /// 添加到"我的今日"
    func addToMyDay(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard !tasks[index].isInMyDay else { return }
        // 创建新实例以触发 SwiftUI 视图刷新
        var updatedTask = tasks[index]
        updatedTask.isInMyDay = true
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }
    
    /// 从"我的今日"移除
    func removeFromMyDay(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].isInMyDay else { return }
        // 创建新实例以触发 SwiftUI 视图刷新
        var updatedTask = tasks[index]
        updatedTask.isInMyDay = false
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }
    
    /// 更新任务的 createdAt 时间（用于调整排序）
    func updateTaskCreatedAt(taskID: UUID, to newDate: Date) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        // 创建新实例以触发 SwiftUI 视图刷新
        var updatedTask = tasks[index]
        updatedTask.createdAt = newDate
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }
    
    // MARK: - Status Changes
    
    /// 开始任务
    func startTask(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].status == .notStarted else { return }
        
        var updatedTask = tasks[index]
        updatedTask.status = .inProgress
        updatedTask.startedAt = Date()
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }
    
    /// 完成任务
    func completeTask(taskID: UUID, endedAt: Date, overtimeAction: OvertimeAction) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].status != .completed else { return }
        
        var updatedTask = tasks[index]
        updatedTask.status = .completed
        updatedTask.completedAt = endedAt
        updatedTask.actualMinutes = calculateActualMinutes(for: updatedTask)
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        
        // 处理超时逻辑
        handleOvertime(sourceTask: updatedTask, actualMinutes: updatedTask.actualMinutes ?? 0, overtimeAction: overtimeAction)
        
        persist()
    }
    
    /// 重新打开任务
    func reopenTask(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        
        var updatedTask = tasks[index]
        updatedTask.status = .notStarted
        updatedTask.startedAt = nil
        updatedTask.completedAt = nil
        updatedTask.actualMinutes = nil
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }
    
    /// 暂停任务
    func pauseTask(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].status == .inProgress else { return }
        
        var updatedTask = tasks[index]
        updatedTask.status = .notStarted
        updatedTask.startedAt = nil
        updatedTask.updatedAt = Date()
        tasks[index] = updatedTask
        persist()
    }
    
    // MARK: - Helper Methods
    
    private func calculateActualMinutes(for task: TaskItem) -> Int {
        guard let startedAt = task.startedAt else { return 0 }
        let duration = Date().timeIntervalSince(startedAt)
        return Int(duration / 60)
    }
}
