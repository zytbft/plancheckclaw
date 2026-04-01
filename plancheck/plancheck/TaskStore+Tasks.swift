    /// 获取今天的任务（已排序）
    /// 包含：1) isInMyDay == true 的任务；2) createdAt 为今天的任务
    func sortedTodayTasks(referenceDate: Date = Date()) -> [TaskItem] {
        let day = Calendar.current.startOfDay(for: referenceDate)
        let currentDayTasks = tasks.filter { task in
            // 条件 1: isInMyDay == true（手动加入今日的任务）
            task.isInMyDay || 
            // 条件 2: createdAt 为今天（今天创建的任务自动加入）
            Calendar.current.isDate(task.createdAt, inSameDayAs: day)
        }
        return taskPriorityService.sortTodayTasksByPriority(currentDayTasks)
    }