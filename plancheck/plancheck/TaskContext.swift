import Foundation

enum TaskContext: String, Codable, CaseIterable {
    case deepWork = "深度工作"
    case shallowWork = "浅层工作"
    case meeting = "会议"
    case personal = "个人事务"
}
