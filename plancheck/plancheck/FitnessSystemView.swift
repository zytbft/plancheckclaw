import SwiftUI

/// 健身系统 - 用于记录训练计划和身体数据
struct FitnessSystemView: View {
    @State private var selectedFitnessTab: FitnessTab = .overview
    @State private var showingAddWorkout = false
    
    enum FitnessTab: String, CaseIterable {
        case overview = "总览"
        case workout = "训练计划"
        case bodyData = "身体数据"
        case nutrition = "营养管理"
        case progress = "进步追踪"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 占位内容 - 后续迭代实现
                ContentUnavailableView(
                    "健身系统开发中",
                    systemImage: "heart.fill",
                    description: Text("用于记录训练计划和身体数据\n\n功能规划：\n• 训练计划与动作库\n• 重量/次数/组数记录\n• 身体指标追踪（体重、体脂等）\n• 进步曲线可视化")
                )
            }
            .padding()
            .navigationTitle("💪 健身系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddWorkout = true }) {
                        Label("添加训练", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutPlaceholderView()
            }
        }
    }
}

/// 添加训练占位视图
struct AddWorkoutPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "添加训练功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持记录训练内容和身体数据")
                )
            }
            .padding()
            .navigationTitle("添加训练")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    FitnessSystemView()
}
