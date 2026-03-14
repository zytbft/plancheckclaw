import Foundation

struct WeeklyReport: Codable, Identifiable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    var totalTasksCompleted: Int
    var totalEstimatedMinutes: Int
    var totalActualMinutes: Int
    var averageCompletionRate: Double
    var topTimeConsumingTasks: [String]
    
    var deviationPercentage: Double {
        guard totalEstimatedMinutes > 0 else { return 0.0 }
        return Double(totalActualMinutes - totalEstimatedMinutes) / Double(totalEstimatedMinutes) * 100
    }
}
