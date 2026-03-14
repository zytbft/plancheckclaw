import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskStore: TaskStore
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                TodayView()
                    .tabItem {
                        Label("今日", systemImage: "calendar")
                    }
                    .tag(0)
                
                AllTasksView()
                    .tabItem {
                        Label("全部", systemImage: "list.bullet")
                    }
                    .tag(1)
                
                ImportantView()
                    .tabItem {
                        Label("重要", systemImage: "star.fill")
                    }
                    .tag(2)
                
                HistoryView()
                    .tabItem {
                        Label("历史", systemImage: "clock.fill")
                    }
                    .tag(3)
                
                SettingsView()
                    .tabItem {
                        Label("设置", systemImage: "gearshape")
                    }
                    .tag(4)
            }
        }
    }
}
