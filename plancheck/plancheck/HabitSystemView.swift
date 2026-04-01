import SwiftUI

/// 习惯系统 - 用于追踪和管理日常习惯养成
struct HabitSystemView: View {
    @State private var selectedHabitCategory: HabitCategory = .all
    @State private var showingAddHabit = false
    
    enum HabitCategory: String, CaseIterable {
        case all = "全部"
        case morning = "晨间习惯"
        case evening = "晚间习惯"
        case health = "健康管理"
        case learning = "学习成长"
        case work = "工作效率"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 占位内容 - 后续迭代实现
                ContentUnavailableView(
                    "习惯系统开发中",
                    systemImage: "checkmark.circle.fill",
                    description: Text("用于追踪和管理日常习惯养成\n\n功能规划：\n• 习惯打卡与连续记录\n• 习惯分类与标签管理\n• 统计数据与可视化\n• 提醒与激励机制")
                )
            }
            .padding()
            .navigationTitle("📈 习惯系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddHabit = true }) {
                        Label("添加习惯", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitPlaceholderView()
            }
        }
    }
}

/// 添加习惯占位视图
struct AddHabitPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "添加习惯功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持创建新的习惯追踪项目")
                )
            }
            .padding()
            .navigationTitle("添加习惯")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HabitSystemView()
}
