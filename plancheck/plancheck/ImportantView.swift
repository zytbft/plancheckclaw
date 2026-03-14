import SwiftUI

struct ImportantView: View {
    @EnvironmentObject var taskStore: TaskStore
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("重要任务")
                    .font(.title)
                    .padding()
                
                // TODO: Add important tasks list here
            }
            .navigationTitle("重要")
        }
    }
}
