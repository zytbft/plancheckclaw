import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskStore: TaskStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var estimatedMinutes = 30
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("任务标题", text: $title)
                    Stepper("预计时长：\(estimatedMinutes) 分钟", value: $estimatedMinutes, in: 15...180, step: 15)
                }
            }
            .navigationTitle("新建任务")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        // TODO: Save task
                        dismiss()
                    }
                }
            }
        }
    }
}
