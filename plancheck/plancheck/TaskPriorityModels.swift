import Foundation

enum PriorityLevel: Int, Codable, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3
    case top = 4
    
    var label: String {
        switch self {
        case .low: return "低"
        case .medium: return "中"
        case .high: return "高"
        case .top: return "顶级"
        }
    }
}

struct PriorityScore: Codable {
    var amount: Double = 0.0
    var daysToCash: Double = 0.0
    var successRate: Double = 0.0
    var leverage: Double = 0.0
    var strategicFit: Double = 0.0
    
    var totalScore: Double {
        return amount * 0.3 +
               daysToCash * 0.25 +
               successRate * 0.2 +
               leverage * 0.15 +
               strategicFit * 0.1
    }
}
