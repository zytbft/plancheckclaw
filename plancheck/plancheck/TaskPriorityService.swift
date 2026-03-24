import Foundation

struct PriorityComputation {
    var cashScore: Double
    var speedScore: Double
    var probScore: Double
    var leverageScore: Double
    var fitScore: Double
    var total: Double
    var tier: PriorityTier
    var reason: String
}

struct TaskPriorityService {
    func recomputePriority(for draft: TaskDraft) -> TaskDraft {
        var next = draft
        let result = compute(
            expectedCashInRMB: draft.expectedCashInRMB,
            expectedDaysToCash: draft.expectedDaysToCash,
            successProbability: draft.successProbability,
            leverageScore: draft.leverageScore,
            strategicFitScore: draft.strategicFitScore
        )
        next.priorityScore = result.total
        next.priorityTier = result.tier.rawValue
        next.priorityReason = result.reason
        next.priorityUpdatedAt = Date()
        return next
    }

    func recomputePriority(for task: TaskItem) -> TaskItem {
        var next = task
        let result = compute(
            expectedCashInRMB: task.expectedCashInRMB,
            expectedDaysToCash: task.expectedDaysToCash,
            successProbability: task.successProbability,
            leverageScore: task.leverageScore,
            strategicFitScore: task.strategicFitScore
        )
        next.priorityScore = result.total
        next.priorityTier = result.tier.rawValue
        next.priorityReason = result.reason
        next.priorityUpdatedAt = Date()
        return next
    }

    func sortDraftsByPriority(_ drafts: [TaskDraft]) -> [TaskDraft] {
        drafts.sorted { lhs, rhs in
            let leftScore = lhs.priorityScore ?? 0
            let rightScore = rhs.priorityScore ?? 0
            if leftScore != rightScore {
                return leftScore > rightScore
            }
            let leftDays = lhs.expectedDaysToCash ?? Int.max
            let rightDays = rhs.expectedDaysToCash ?? Int.max
            if leftDays != rightDays {
                return leftDays < rightDays
            }
            return lhs.title < rhs.title
        }
    }

    func sortTodayTasksByPriority(_ tasks: [TaskItem]) -> [TaskItem] {
        tasks.sorted { (lhs: TaskItem, rhs: TaskItem) in
            // 置顶任务始终排在最前面
            if lhs.isPinned != rhs.isPinned {
                return lhs.isPinned && !rhs.isPinned
            }

            // 已开始的任务（进行中）优先级最高，排在其他状态前面
            if lhs.status != rhs.status {
                if lhs.status == .inProgress { return true }
                if rhs.status == .inProgress { return false }
            }

            // 未完成的任务（待开始）始终排在已完成任务（已完成、已放弃）之前
            let lhsIsPending = lhs.status.isPending
            let rhsIsPending = rhs.status.isPending
            if lhsIsPending != rhsIsPending {
                return lhsIsPending && !rhsIsPending
            }

            // 已完成任务内部按完成时间倒序排序（最新完成的在最上面）
            if lhs.status == .completed && rhs.status == .completed {
                // 优先使用 endedAt（完成时间），如果为空则使用 updatedAt
                let lhsEndTime = lhs.endedAt ?? lhs.updatedAt
                let rhsEndTime = rhs.endedAt ?? rhs.updatedAt
                return lhsEndTime > rhsEndTime  // 倒序：新完成的在前
            }

            // 同状态下按优先级分数排序
            let leftScore = lhs.priorityScore ?? 0
            let rightScore = rhs.priorityScore ?? 0
            if leftScore != rightScore {
                return leftScore > rightScore
            }

            // 优先级分数相同则按预计回款天数排序
            let leftDays = lhs.expectedDaysToCash ?? Int.max
            let rightDays = rhs.expectedDaysToCash ?? Int.max
            if leftDays != rightDays {
                return leftDays < rightDays
            }

            // 最后按创建时间和标题排序
            // 对于待处理任务（未开始），新创建的任务排在前面（倒序）
            if lhs.status.isPending && rhs.status.isPending {
                return lhs.createdAt > rhs.createdAt  // 新任务优先
            }
            
            // 其他状态按创建时间升序
            if lhs.createdAt != rhs.createdAt {
                return lhs.createdAt < rhs.createdAt
            }
            return lhs.title < rhs.title
        }
    }

    private func compute(
        expectedCashInRMB: Int?,
        expectedDaysToCash: Int?,
        successProbability: Double?,
        leverageScore: Int,
        strategicFitScore: Int
    ) -> PriorityComputation {
        let cash = max(0, expectedCashInRMB ?? 0)
        let days = max(1, expectedDaysToCash ?? 30)
        let probability = clamp(successProbability ?? 0.5, min: 0, max: 1)
        let leverage = clamp(Double(leverageScore), min: 1, max: 5)
        let fit = clamp(Double(strategicFitScore), min: 1, max: 5)

        let cashScore = clamp(log10(Double(cash + 1)) / 5.0, min: 0, max: 1)
        let speedScore = 1.0 - clamp(Double(days - 1) / 89.0, min: 0, max: 1)
        let probScore = probability
        let leverageNormalized = (leverage - 1.0) / 4.0
        let fitNormalized = (fit - 1.0) / 4.0

        let total =
            0.35 * cashScore
            + 0.25 * speedScore
            + 0.20 * probScore
            + 0.15 * leverageNormalized
            + 0.05 * fitNormalized

        let tier: PriorityTier
        if total >= 0.75 {
            tier = .a
        } else if total >= 0.55 {
            tier = .b
        } else {
            tier = .c
        }

        let reason = "现金\(percent(cashScore)) · 速度\(percent(speedScore)) · 成功率\(percent(probScore))"
        return PriorityComputation(
            cashScore: cashScore,
            speedScore: speedScore,
            probScore: probScore,
            leverageScore: leverageNormalized,
            fitScore: fitNormalized,
            total: total,
            tier: tier,
            reason: reason
        )
    }

    private func clamp(_ value: Double, min: Double, max: Double) -> Double {
        Swift.min(Swift.max(value, min), max)
    }

    private func percent(_ value: Double) -> String {
        "\(Int((value * 100).rounded()))%"
    }
}
