import SwiftUI

struct EditTaskView: View {
    let task: TaskItem
    let onSave: (String, Int, TaskContext, String?, Bool) -> Void

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var taskStore: TaskStore
    @State private var title: String
    @State private var estimatedMinutes: String
    @State private var context: TaskContext
    @State private var notes: String
    @State private var isImportant: Bool
    
    init(task: TaskItem, onSave: @escaping (String, Int, TaskContext, String?, Bool) -> Void) {
        self.task = task
        self.onSave = onSave
        _title = State(initialValue: task.title)
        _estimatedMinutes = State(initialValue: String(task.estimatedMinutes))
        _context = State(initialValue: task.context)
        _notes = State(initialValue: task.notes ?? "")
        _isImportant = State(initialValue: task.isImportant)
    }
    
    private var normalizedTitle: String {
        TaskItem.normalizedTitle(title)
    }
    
    private var parsedEstimatedMinutes: Int? {
        guard let value = Int(estimatedMinutes.trimmingCharacters(in: .whitespacesAndNewlines)),
              TaskItem.isValidMinutes(value) else {
            return nil
        }
        return value
    }
    
    private var isFormValid: Bool {
        !normalizedTitle.isEmpty && parsedEstimatedMinutes != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("任务信息") {
                    TextField("任务标题", text: $title, axis: .vertical)
                    
                    Picker("上下文", selection: $context) {
                        ForEach(TaskContext.allCases, id: \.self) { context in
                            Text(context.rawValue).tag(context)
                        }
                    }
                    
                    TextField("备注（可选）", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("编辑任务")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        save()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func save() {
        guard let minutes = parsedEstimatedMinutes else { return }
        onSave(normalizedTitle, minutes, context, notes.isEmpty ? nil : notes, isImportant)
        dismiss()
    }
}
