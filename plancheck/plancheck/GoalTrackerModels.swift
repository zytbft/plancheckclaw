import Foundation

// MARK: - 目标追踪数据模型

/// 人生目标追踪数据结构
/// 
/// 注意：MVP 版本使用手动录入，未来版本可扩展为自动统计
struct GoalTrackerData: Codable {
    // MARK: - 核心目标
    
    /// 当前被动收入（元）- 起点 60 万
    var currentWealth: Int = 600_000
    
    /// 健康评分 (0-100)
    var currentHealth: Int = 0
    
    /// 已完成研报数量（目标 20 份）
    var currentGrowth: Int = 0
    
    // MARK: - 习惯追踪
    
    /// 连续深度工作天数
    var deepWorkDays: Int = 0
    
    /// 本周运动次数（目标 5 次）
    var workoutCount: Int = 0
    
    /// 平均睡眠时长（小时/天）
    var sleepHours: Double = 0.0
    
    /// 投资年化收益率（%）
    var roiRate: Double = 0.0
    
    // MARK: - 元数据
    
    /// 最后更新时间
    var lastUpdatedAt: Date = Date()
    
    // MARK: - 计算属性
    
    /// 财富目标进度百分比 (基于起点 60 万，目标 1 亿)
    var wealthProgressPercent: Double {
        let numerator = Double(currentWealth - 600_000)
        let denominator = Double(100_000_000 - 600_000)
        guard denominator > 0 else { return 0 }
        return min(100.0, max(0.0, numerator / denominator * 100))
    }
    
    /// 健康目标进度百分比 (0-100)
    var healthProgressPercent: Double {
        return min(100.0, max(0.0, Double(currentHealth)))
    }
    
    /// 成长目标进度百分比 (目标 20 份研报)
    var growthProgressPercent: Double {
        return min(100.0, max(0.0, Double(currentGrowth) / 20.0 * 100))
    }
}

// MARK: - 名言数据模型

/// 激励名言
struct InspirationalQuote {
    let text: String
    let author: String
    
    static let allQuotes: [InspirationalQuote] = [
        InspirationalQuote(text: "市场先生是仆人不是向导", author: "沃伦·巴菲特"),
        InspirationalQuote(text: "151 岁的旅程，从今天开始", author: "你自己"),
        InspirationalQuote(text: "年入 1 亿的梦想，从今晚的 2 小时深度工作起步", author: "你自己"),
        InspirationalQuote(text: "价格是你付出的，价值是你得到的", author: "沃伦·巴菲特"),
        InspirationalQuote(text: "如果你不愿意持有一只股票 10 年，就不要持有它 10 分钟", author: "沃伦·巴菲特"),
        InspirationalQuote(text: "复利是世界第八大奇迹", author: "阿尔伯特·爱因斯坦"),
        InspirationalQuote(text: "知识就是力量，尤其是当它能产生复利时", author: "查理·芒格"),
        InspirationalQuote(text: "每天进步 1%，一年后你会进步 37 倍", author: "原子习惯")
    ]
    
    static var random: InspirationalQuote {
        allQuotes.randomElement() ?? allQuotes[0]
    }
}

// MARK: - 今日行动项（桥接 TaskItem）

/// 今日行动项 - 用于在行动清单中展示任务
struct ActionItem: Identifiable {
    let id = UUID()
    let task: TaskItem
    
    var text: String {
        task.title
    }
    
    var time: String {
        if task.estimatedMinutes >= 60 {
            let hours = task.estimatedMinutes / 60
            let minutes = task.estimatedMinutes % 60
            if minutes > 0 {
                return "\(hours)小时\(minutes)分"
            }
            return "\(hours)小时"
        }
        return "\(task.estimatedMinutes)分钟"
    }
    
    var isCompleted: Bool {
        task.status == .completed
    }
}

// MARK: - 倒计时结果

/// 倒计时计算结果
struct CountdownResult {
    let totalDays: Int
    let years: Int
    let months: Int
    let days: Int
    
    var formattedDays: String {
        totalDays.toLocaleString()
    }
    
    var formattedYMD: String {
        "\(years)年 \(months)月 \(days)天"
    }
}

// MARK: - Helper Extensions

extension Int {
    func toLocaleString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

// MARK: - 未来扩展接口

/*
 // TODO: 未来版本支持自动统计时，添加以下功能：
 
 extension GoalTrackerData {
     /// 自动更新深度工作天数（从 TaskStore 统计）
     mutating func autoUpdateDeepWorkDays(from tasks: [TaskItem]) {
         // 统计连续完成深度工作任务的天数
         // ...
     }
     
     /// 自动更新运动次数（从完成任务中统计）
     mutating func autoUpdateWorkoutCount(from completedTasks: [TaskItem]) {
         // 统计本周完成的运动类任务
         // ...
     }
     
     /// 自动更新睡眠数据（如果集成健康应用）
     mutating func autoUpdateSleepData(from healthKitData: ...) {
         // 从 HealthKit 读取睡眠数据
         // ...
     }
 }
 */
