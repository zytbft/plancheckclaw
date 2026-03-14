import SwiftUI

struct AllTasksView: View {
    @EnvironmentObject var taskStore: TaskStore
    
    var body: some View {
        VStack {
            Text("全部任务")
                .font(.title)
                .padding()
            
            // TODO: Add all tasks list here
        }
    }
}
