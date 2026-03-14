import SwiftUI

struct TrashView: View {
    @EnvironmentObject var taskStore: TaskStore
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("回收站")
                    .font(.title)
                    .padding()
                
                // TODO: Add deleted tasks list here
            }
            .navigationTitle("回收站")
        }
    }
}
