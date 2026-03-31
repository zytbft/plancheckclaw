import Foundation

// MARK: - Task Operations Extension
extension TaskStore {
    
    // MARK: - Helper Methods (Private)
    
    /// 持久化任务数据
    func persist() {
        do {
            let dir = taskFileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            let data = try encoder.encode(tasks)
            try data.write(to: taskFileURL, options: .atomic)
            syncToICloudIfNeeded()
        } catch {
            print("保存任务数据失败：\(error.localizedDescription)")
        }
    }
    
    /// 根据历史数据建议任务的预估时间
    func suggestedEstimatedMinutes(for title: String) -> Int? {
        let key = TaskItem.normalizedCategoryKey(title)
        guard !key.isEmpty else { return nil }
        
        let sameCategory = tasks.filter {
            TaskItem.normalizedCategoryKey($0.title) == key
        }
        guard !sameCategory.isEmpty else { return nil }
        
        let completedActuals =
            sameCategory
            .filter { $0.status == .completed }
            .compactMap(\.actualMinutes)
            .filter(TaskItem.isValidMinutes)
        
        let candidates =
            completedActuals.isEmpty
            ? sameCategory.map(\.estimatedMinutes).filter(TaskItem.isValidMinutes)
            : completedActuals
        
        return medianMinutes(candidates)
    }
    
    /// 计算中位数分钟数
    private func medianMinutes(_ values: [Int]) -> Int? {
        guard !values.isEmpty else { return nil }
        let sorted = values.sorted()
        let mid = sorted.count / 2
        if sorted.count % 2 == 1 {
            return sorted[mid]
        }
        let average = Double(sorted[mid - 1] + sorted[mid]) / 2.0
        return Int(average.rounded())
    }
    
    /// 检查任务是否已被转入到指定日期
    func hasBeenCarriedOverToDate(originTask: TaskItem, date: Date) -> Bool {
        let calendar = Calendar.current
        if let carriedDate = originTask.lastCarriedOverAt,
            calendar.isDate(carriedDate, inSameDayAs: date)
        {
            return true
        }
        
        return tasks.contains {
            $0.sourceTaskID == originTask.id && calendar.isDate($0.createdAt, inSameDayAs: date)
        }
    }
    
    /// 计算状态优先级数值
    private func priority(for status: TaskProgressStatus) -> Int {
        switch status {
        case .inProgress:
            return 0
        case .notStarted:
            return 1
        case .completed:
            return 2
        case .abandoned:
            return 3
        }
    }
    
    /// 计算日期索引
    private func dayIndex(for date: Date) -> Int {
        Int(Calendar.current.startOfDay(for: date).timeIntervalSince1970 / 86_400)
    }
    
    // MARK: - Add Tasks
    
    // MARK: - Add Tasks
    
    /// 添加新任务
    func addTask(
        title: String,
        estimatedMinutes: Int,
        context: TaskContext = .deepWork,
        notes: String? = nil,
        isImportant: Bool = false
    ) {
        let trimmed = TaskItem.normalizedTitle(title)
        guard !trimmed.isEmpty, TaskItem.isValidMinutes(estimatedMinutes) else { return }
        let task = TaskItem(
            title: trimmed,
            estimatedMinutes: estimatedMinutes,
            context: context,
            notes: notes,
            isImportant: isImportant
        )
        
        // 找到合适的插入位置：置顶任务和已开始任务的后面
        let insertIndex = findInsertIndex(for: task)
        tasks.insert(task, at: insertIndex)
        
        persist()
    }
    
    /// 找到新任务的合适插入位置
    private func findInsertIndex(for newTask: TaskItem) -> Int {
        // 遍历现有任务，找到第一个既不是置顶也不是已开始的任务位置
        for (index, existingTask) in tasks.enumerated() {
            // 如果当前任务是置顶或已开始的，新任务应该在其后面
            if existingTask.isPinned || existingTask.status == .inProgress {
                continue
            }
            // 找到了第一个非置顶、非已开始的任务，插在前面
            return index
        }
        // 如果所有任务都是置顶或已开始的，或者没有任务，则添加到末尾
        return tasks.count
    }
    
    /// 从模板或其他来源添加任务（不检查重复）
    func addTaskFromTemplate(_ task: TaskItem) {
        tasks.append(task)
        persist()
    }
    
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
        
        // ✅ 创建新的 TaskItem 对象来替换原对象
        let originalTask = tasks[index]
        var updatedTask = TaskItem(
            title: trimmed,
            estimatedMinutes: estimatedMinutes,
            createdAt: originalTask.createdAt,
            sourceTaskID: originalTask.sourceTaskID,
            carryOverCount: originalTask.carryOverCount,
            context: context,
            status: originalTask.status,
            notes: TaskItem.normalizedNotes(notes),
            isImportant: isImportant,
            isPinned: originalTask.isPinned,
            isInMyDay: originalTask.isInMyDay,
            startedAt: originalTask.startedAt,
            endedAt: originalTask.endedAt,
            expectedCashInRMB: originalTask.expectedCashInRMB,
            expectedDaysToCash: originalTask.expectedDaysToCash,
            successProbability: originalTask.successProbability,
            leverageScore: originalTask.leverageScore,
            strategicFitScore: originalTask.strategicFitScore,
            priorityScore: originalTask.priorityScore,
            priorityTier: originalTask.priorityTier,
            priorityReason: originalTask.priorityReason,
            priorityUpdatedAt: originalTask.priorityUpdatedAt
        )
        
        // ✅ 手动设置 ID 以保持与原任务一致
        updatedTask.id = originalTask.id
        
        // ✅ 替换整个对象以触发 @Published 通知
        tasks[index] = updatedTask
        
        // ✅ 强制触发 @Published 通知
        objectWillChange.send()
        
        persist()
    }
    
    /// 切换任务的重要状态
    func toggleImportant(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        
        // ✅ 创建新对象以触发 @Published 通知
        var updatedTask = tasks[index]
        updatedTask.isImportant.toggle()
        updatedTask.updatedAt = Date()
        
        tasks[index] = updatedTask
        persist()
    }

    /// 切换任务的置顶状态
    func togglePinned(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        
        // ✅ 创建新对象以触发 @Published 通知
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
        
        // ✅ 创建新对象以触发 @Published 通知
        var updatedTask = tasks[index]
        updatedTask.isInMyDay = true
        updatedTask.updatedAt = Date()
        
        tasks[index] = updatedTask
        
        // ✅ 强制触发 @Published 通知
        objectWillChange.send()
        
        persist()
    }
    
    /// 从"我的今日"移除
    func removeFromMyDay(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].isInMyDay else { return }
        
        // ✅ 创建新对象以触发 @Published 通知
        var updatedTask = tasks[index]
        updatedTask.isInMyDay = false
        updatedTask.updatedAt = Date()
        
        tasks[index] = updatedTask
        
        // ✅ 强制触发 @Published 通知
        objectWillChange.send()
        
        persist()
    }
