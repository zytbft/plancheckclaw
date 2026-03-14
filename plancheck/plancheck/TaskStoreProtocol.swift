import Foundation

protocol TaskStoreProtocol {
    func addTask(_ task: TaskItem)
    func updateTask(_ task: TaskItem)
    func deleteTask(id: UUID)
    func getTodayTasks() -> [TaskItem]
    func getAllTasks() -> [TaskItem]
}
