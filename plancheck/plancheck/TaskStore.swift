import Foundation

// MARK: - Error Types

enum FolderSyncError: LocalizedError {
    case invalidDirectory
    case createDirectoryFailed
    case writeFailed

    var errorDescription: String? {
        switch self {
        case .invalidDirectory:
            return "请选择可用的目录。"
        case .createDirectoryFailed:
            return "创建同步目录失败。"
        case .writeFailed:
            return "写入同步数据失败。"
        }
    }
}

// MARK: - Data Models

struct BulkTaskPlanImportResult {
    var addedCount: Int
    var skippedCount: Int
    var totalEstimatedMinutes: Int
    var createdTaskIDs: [UUID] = []
}

struct DeletedTask: Identifiable, Codable {
    var id: UUID
    var task: TaskItem
    var deletedAt: Date
    var reason: DeletedTask.DeleteReason

    enum DeleteReason: String, Codable {
        case manual
        case bulk
        case abandoned
    }
}
