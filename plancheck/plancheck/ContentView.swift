import SwiftUI

struct ContentView: View {
    @StateObject private var searchState = SearchState()
    @EnvironmentObject private var taskStore: TaskStore
    @State private var selectedTab: Tab = .today
    @State private var showingAddTask = false
    @State private var showingSettings = false
    @State private var showingTrash = false

    enum Tab: Hashable {
        case today, allTasks, important, history, weekly, goalTracker, mindBody, lifeSystems, muskAssistant, trash
    }

    var body: some View {
        NavigationSplitView {
            // 侧边栏
            VStack(spacing: 0) {
                // 全局搜索框
                SearchBarView(searchText: $searchState.searchText, placeholder: "搜索任务...")
                    .padding(8)

                List(selection: $selectedTab) {
                    Label("今日任务", systemImage: "list.bullet")
                        .tag(Tab.today)
                    Label("全部任务", systemImage: "square.grid.2x2")
                        .tag(Tab.allTasks)
                    Label("目标看板", systemImage: "chart.line.uptrend.xyaxis")
                        .tag(Tab.goalTracker)
                    Label("天人合一", systemImage: "figure.mind.and.body")
                        .tag(Tab.mindBody)
                    Label("重要任务", systemImage: "star")
                        .tag(Tab.important)
                    Label("历史记录", systemImage: "clock.arrow.circlepath")
                        .tag(Tab.history)
                    Label("每周报告", systemImage: "chart.bar.xaxis")
                        .tag(Tab.weekly)
                    
                    Divider()
                    
                    Label("⚡ 超级 Musk", systemImage: "brain.head.profile")
                        .tag(Tab.muskAssistant)
                                    
                    Label("🎯 人生系统", systemImage: "target")
                        .tag(Tab.lifeSystems)
                    
                    Divider()
                                    
                    Label("回收站", systemImage: "trash")
                        .tag(Tab.trash)
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 150)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            }
        } detail: {
            Group {
                switch selectedTab {
                case .today:
                    TodayView()
                        .environmentObject(searchState)
                case .allTasks:
                    AllTasksView()
                        .environmentObject(searchState)
                case .goalTracker:
                    GoalTrackerView()
                        .environmentObject(taskStore)
                case .mindBody:
                    MindBodyView()
                case .muskAssistant:
                    MuskAssistantView()
                case .lifeSystems:
                    LifeSystemsMenuView()
                case .important:
                    ImportantView()
                case .history:
                    HistoryView()
                case .weekly:
                    WeeklyReportView()
                case .trash:
                    TrashView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showingAddTask = true
                } label: {
                    Label("添加任务", systemImage: "plus")
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            ToolbarItem {
                Button {
                    showingSettings = true
                } label: {
                    Label("设置", systemImage: "gearshape")
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .keyboardShortcut("f", modifiers: .command)
    }
}
