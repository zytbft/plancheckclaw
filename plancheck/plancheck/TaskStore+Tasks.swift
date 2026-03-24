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
        
        tasks[index].title = trimmed
        tasks[index].estimatedMinutes = estimatedMinutes
        tasks[index].context = context
        tasks[index].notes = TaskItem.normalizedNotes(notes)
        tasks[index].isImportant = isImportant
        tasks[index].updatedAt = Date()
        persist()
    }
    
    /// 切换任务的重要状态
    func toggleImportant(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].isImportant.toggle()
        tasks[index].updatedAt = Date()
        persist()
    }

    /// 切换任务的置顶状态
    func togglePinned(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].isPinned.toggle()
        tasks[index].updatedAt = Date()
        persist()
    }

    /// 添加到"我的今日"
    func addToMyDay(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard !tasks[index].isInMyDay else { return }
        tasks[index].isInMyDay = true
        tasks[index].updatedAt = Date()
        persist()
    }
    
    /// 从"我的今日"移除
    func removeFromMyDay(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].isInMyDay else { return }
        tasks[index].isInMyDay = false
        tasks[index].updatedAt = Date()
        persist()
    }
    
    /// 更新任务的 createdAt 时间（用于调整排序）
    func updateTaskCreatedAt(taskID: UUID, to newDate: Date) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].createdAt = newDate
        tasks[index].updatedAt = Date()
        persist()
    }
    
    // MARK: - Task Status Transitions
    
    /// 开始任务
    func startTask(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        guard tasks[index].status == .notStarted else { return }
        tasks[index].status = .inProgress
        tasks[index].startedAt = Date()
        tasks[index].endedAt = nil
        tasks[index].actualMinutes = nil
        tasks[index].updatedAt = Date()
        let startedTask = tasks[index]
        persist()
        triggerTaskAutomation(for: startedTask)
    }
    
    /// 完成任务
    func completeTask(
        taskID: UUID, endedAt: Date = Date(), overtimeAction: OvertimeAction = .complete
    ) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        let sourceTask = tasks[index]
        let actualMinutes = computedActualMinutes(for: sourceTask, endedAt: endedAt)
        
        tasks[index].actualMinutes = actualMinutes
        tasks[index].status = .completed
        tasks[index].endedAt = endedAt
        tasks[index].updatedAt = endedAt
        
        if actualMinutes > sourceTask.estimatedMinutes {
            handleOvertime(
                sourceTask: sourceTask, actualMinutes: actualMinutes, overtimeAction: overtimeAction
            )
        }
        persist()
    }
    
    /// 重新打开任务
    func reopenTask(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .inProgress
        tasks[index].actualMinutes = nil
        tasks[index].startedAt = Date()
        tasks[index].endedAt = nil
        tasks[index].updatedAt = Date()
        persist()
    }
    
    /// 暂停任务（从"进行中"改回"待处理"）
    func pauseTask(taskID: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .notStarted
        tasks[index].startedAt = nil
        tasks[index].endedAt = nil
        tasks[index].updatedAt = Date()
        persist()
    }
    
    /// 放弃任务
    func abandonTasks(taskIDs: [UUID]) {
        guard !taskIDs.isEmpty else { return }
        var changed = false
        for id in taskIDs {
            guard let index = tasks.firstIndex(where: { $0.id == id }) else { continue }
            guard tasks[index].status.isPending else { continue }
            tasks[index].status = .abandoned
            tasks[index].updatedAt = Date()
            changed = true
        }
        if changed {
            persist()
        }
    }
    
    // MARK: - Task Carry Over
    
    /// 获取所有未完成且需要转入到今天的历史任务
    func yesterdayIncompleteTasks(referenceDate: Date = Date(), maxCarryDays: Int) -> [TaskItem] {
        guard maxCarryDays > 0 else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: referenceDate)
        
        // 计算最早需要处理的日期（今天往前推 maxCarryDays 天）
        guard let earliestDate = calendar.date(byAdding: .day, value: -maxCarryDays, to: today) else { return [] }
        
        return tasks.filter {
            // 任务创建时间在范围内（从 earliestDate 到昨天）
            $0.createdAt >= earliestDate && $0.createdAt < today
            // 状态是待开始或进行中
                && $0.status.isPending
            // 转入次数未达到上限
                && $0.carryOverCount < maxCarryDays
            // 今天还没有被转入过
                && !hasBeenCarriedOverToDate(originTask: $0, date: referenceDate)
        }
    }
    
    /// 转入任务到今天
    func carryOver(taskIDs: [UUID], maxCarryDays: Int, to date: Date = Date()) {
        guard !taskIDs.isEmpty, maxCarryDays > 0 else { return }
        
        var didChange = false
        for taskID in taskIDs {
            guard let sourceIndex = tasks.firstIndex(where: { $0.id == taskID }) else { continue }
            let source = tasks[sourceIndex]
            guard source.carryOverCount < maxCarryDays else { continue }
            guard !hasBeenCarriedOverToDate(originTask: source, date: date) else { continue }
            
            // 1. 创建新任务到今日
            let newTask = TaskItem(
                title: source.title,
                estimatedMinutes: source.estimatedMinutes,
                createdAt: date,
                sourceTaskID: source.id,
                carryOverCount: source.carryOverCount + 1,
                context: source.context,
                notes: source.notes,
                isImportant: source.isImportant
            )
            tasks.append(newTask)
            
            // 2. 将原任务标记为已放弃（避免在全部任务中重复显示）
            tasks[sourceIndex].status = .abandoned
            tasks[sourceIndex].lastCarriedOverAt = date
            tasks[sourceIndex].updatedAt = Date()
            
            print("[午夜转入] 任务 \(source.title.prefix(20)) 已转入今天 (第 \(source.carryOverCount + 1) 次)，原任务已标记为已放弃")
            didChange = true
        }
        
        if didChange {
            persist()
        }
    }
    
    /// 获取今天的任务（已排序）
    func sortedTodayTasks(referenceDate: Date = Date()) -> [TaskItem] {
        let day = Calendar.current.startOfDay(for: referenceDate)
        let currentDayTasks = tasks.filter {
            Calendar.current.isDate($0.createdAt, inSameDayAs: day)
        }
        return taskPriorityService.sortTodayTasksByPriority(currentDayTasks)
    }
    
    /// 获取今天优先级最高的任务
    func topPriorityTasksForToday(referenceDate: Date = Date(), limit: Int = 3) -> [TaskItem] {
        sortedTodayTasks(referenceDate: referenceDate)
            .filter { $0.priorityTier == PriorityTier.a.rawValue && $0.status.isPending }
            .prefix(max(1, limit))
            .map { $0 }
    }
    
    /// 获取"我的今日"推荐任务
    func myDaySuggestions(referenceDate: Date = Date(), limit: Int = 5) -> [TaskItem] {
        let day = Calendar.current.startOfDay(for: referenceDate)
        return
            tasks
            .filter {
                Calendar.current.isDate($0.createdAt, inSameDayAs: day)
                    && $0.status.isPending
                    && !$0.isInMyDay
            }
            .sorted { lhs, rhs in
                // 置顶任务优先
                if lhs.isPinned != rhs.isPinned {
                    return lhs.isPinned && !rhs.isPinned
                }
                // 已开始的任务其次
                if lhs.status != rhs.status {
                    return priority(for: lhs.status) < priority(for: rhs.status)
                }
                if lhs.isImportant != rhs.isImportant {
                    return lhs.isImportant && !rhs.isImportant
                }
                if lhs.carryOverCount != rhs.carryOverCount {
                    return lhs.carryOverCount > rhs.carryOverCount
                }
                if lhs.createdAt != rhs.createdAt {
                    return lhs.createdAt < rhs.createdAt
                }
                return lhs.title < rhs.title
            }
            .prefix(max(1, limit))
            .map { $0 }
    }
    
    /// 重置"我的今日"（如果需要）
    func resetMyDayIfNeeded(referenceDate: Date = Date()) {
        let todayIndex = dayIndex(for: referenceDate)
        let defaults = UserDefaults.standard
        let lastIndex = defaults.integer(forKey: AppSettingsKeys.lastMyDayResetDay)
        let hasStored = defaults.object(forKey: AppSettingsKeys.lastMyDayResetDay) != nil
        if hasStored, lastIndex == todayIndex {
            return
        }
        
        var changed = false
        for idx in tasks.indices {
            guard tasks[idx].isInMyDay else { continue }
            tasks[idx].isInMyDay = false
            tasks[idx].updatedAt = Date()
            changed = true
        }
        if changed {
            persist()
        }
        defaults.set(todayIndex, forKey: AppSettingsKeys.lastMyDayResetDay)
    }
    
    /// 获取指定日期的任务
    func tasksForDay(_ date: Date = Date()) -> [TaskItem] {
        let day = Calendar.current.startOfDay(for: date)
        return tasks.filter { Calendar.current.isDate($0.createdAt, inSameDayAs: day) }
    }
    
    /// 搜索任务
    func searchTasks(query: String, limit: Int = 50) -> [TaskItem] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmedQuery.isEmpty else {
            return []
        }
        
        let searchTerms = trimmedQuery.split(separator: " ").map(String.init)
        let matches = tasks.filter { task in
            searchTerms.allSatisfy { term in
                task.title.lowercased().contains(term)
                    || (task.notes?.lowercased().contains(term) ?? false)
            }
        }
        
        // 按相关度排序：标题匹配优先于备注匹配
        return
            matches
            .sorted { a, b in
                // 首先按创建时间倒序
                if a.createdAt != b.createdAt {
                    return a.createdAt > b.createdAt
                }
                return a.title < b.title
            }
            .prefix(limit)
            .map { $0 }
    }
    
    // MARK: - Helper Methods

}
