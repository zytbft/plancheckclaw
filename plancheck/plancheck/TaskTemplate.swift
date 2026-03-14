import Foundation

struct TaskTemplate: Codable, Identifiable {
    let id: UUID
    var title: String
    var estimatedMinutes: Int
    var context: TaskContext
    var notes: String?
    
    init(id: UUID = UUID(), title: String, estimatedMinutes: Int, context: TaskContext = .deepWork, notes: String? = nil) {
        self.id = id
        self.title = title
        self.estimatedMinutes = estimatedMinutes
        self.context = context
        self.notes = notes
    }
}
