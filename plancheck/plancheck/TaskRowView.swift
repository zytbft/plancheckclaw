import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    var onToggleStatus: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: statusIcon)
                .foregroundColor(statusColor)
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                
                HStack {
                    Label(task.status.rawValue, systemImage: "clock")
                        .font(.caption)
                    
                    if let actual = task.actualMinutes {
                        Text("\(actual)分钟")
                            .font(.caption)
                    } else {
                        Text("预计\(task.estimatedMinutes)分钟")
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private var statusIcon: String {
        switch task.status {
        case .pending: return "circle"
        case .inProgress: return "arrow.right.circle.fill"
        case .completed: return "checkmark.circle.fill"
        case .abandoned: return "xmark.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch task.status {
        case .pending: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        case .abandoned: return .red
        }
    }
}
