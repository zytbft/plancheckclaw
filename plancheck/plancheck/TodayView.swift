import SwiftUI

struct TodayView: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var showingAddTask = false
    
    var body: some View {
        VStack {
            Text("今日任务")
                .font(.title)
                .padding()
            
            // TODO: Add task list here
            
            Button(action: {
                showingAddTask = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
            }
            .padding()
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
    }
}
