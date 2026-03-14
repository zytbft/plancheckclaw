import Foundation

struct DailyReview: Codable, Identifiable {
    let id: UUID
    let date: Date
    var tasksCompleted: Int
    var totalEstimatedMinutes: Int
    var totalActualMinutes: Int
    var energyLevel: Int?
    var notes: String?
    
    var completionRate: Double {
        guard totalEstimatedMinutes > 0 else { return 0.0 }
        return Double(tasksCompleted) / Double(totalEstimatedMinutes)
    }
}
