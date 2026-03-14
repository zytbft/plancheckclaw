import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var taskStore: TaskStore
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("历史记录")
                    .font(.title)
                    .padding()
                
                // TODO: Add history list here
            }
            .navigationTitle("历史")
        }
    }
}
