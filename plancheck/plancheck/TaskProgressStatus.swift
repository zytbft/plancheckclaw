import Foundation

struct TaskProgressStatus {
    let taskId: UUID
    let plannedMinutes: Int
    let actualMinutes: Int?
    let deviation: Double
    
    var isOverdue: Bool {
        guard let actual = actualMinutes else { return false }
        return actual > plannedMinutes
    }
    
    var deviationPercentage: Double {
        guard let actual = actualMinutes else { return 0.0 }
        return Double(actual - plannedMinutes) / Double(plannedMinutes) * 100
    }
}
