import SwiftUI

struct TaskItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var estimatedMinutes: Int
    var actualMinutes: Int?
    var status: Status
    var priority: Priority
    var context: Context
    var notes: String
    var createdAt: Date
    var startedAt: Date?
    var completedAt: Date?
    
    enum Status: String, Codable, CaseIterable {
        case pending = "待处理"
        case inProgress = "进行中"
        case completed = "已完成"
        case abandoned = "已放弃"
    }
    
    enum Priority: String, Codable, CaseIterable {
        case low = "低"
        case medium = "中"
        case high = "高"
        case top = "顶级"
    }
    
    enum Context: String, Codable, CaseIterable {
        case deepWork = "深度工作"
        case shallowWork = "浅层工作"
        case meeting = "会议"
        case personal = "个人事务"
    }
}
