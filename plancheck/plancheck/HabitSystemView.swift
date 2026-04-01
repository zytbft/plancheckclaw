import SwiftUI

/// 习惯系统 - 用于追踪和管理日常习惯养成
/// 
/// 📚 需求来源：docs/01-需求/00人生系统需求/01习惯系统.docx
/// 
/// 核心功能规划：
/// - 个人档案管理（资金储备、核心技能、行业经验、人脉网络）
/// - 核心能力模型（生存与学习适应力、机会洞察与开拓力、体系化构建与领导力）
/// - 每日习惯打卡（呼吸法、冥想、健身、晨间/晚间习惯）
/// - 习惯分类与标签管理
/// - 统计数据与可视化
/// - 提醒与激励机制
struct HabitSystemView: View {
    @State private var selectedHabitCategory: HabitCategory = .all
    @State private var showingAddHabit = false
    @State private var showingPersonalProfile = false
    
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
                // 快速入口
                quickAccessSection
                
                // 习惯分类选择器
                categorySelector
                
                // 习惯列表（TODO: 后续实现）
                habitListPlaceholder
            }
            .padding()
            .navigationTitle("📈 习惯系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: { showingPersonalProfile = true }) {
                            Label("个人档案", systemImage: "person.fill")
                        }
                        Button(action: { showingAddHabit = true }) {
                            Label("添加习惯", systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitPlaceholderView()
            }
            .sheet(isPresented: $showingPersonalProfile) {
                PersonalProfileView()
            }
        }
    }
    
    // MARK: - Quick Access Section
    
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚡ 快速入口")
                .font(.headline)
            
            HStack(spacing: 12) {
                QuickAccessButton(
                    icon: "wind",
                    title: "呼吸法",
                    color: .blue,
                    action: {
                        // TODO: 打开呼吸法练习界面
                        print("TODO: 打开呼吸法练习")
                    }
                )
                
                QuickAccessButton(
                    icon: "brain.head.profile",
                    title: "冥想",
                    color: .purple,
                    action: {
                        // TODO: 打开冥想练习界面
                        print("TODO: 打开冥想练习")
                    }
                )
                
                QuickAccessButton(
                    icon: "heart.fill",
                    title: "健身",
                    color: .red,
                    action: {
                        // TODO: 打开健身界面
                        print("TODO: 打开健身界面")
                    }
                )
                
                QuickAccessButton(
                    icon: "book.fill",
                    title: "学习",
                    color: .green,
                    action: {
                        // TODO: 打开学习界面
                        print("TODO: 打开学习界面")
                    }
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Category Selector
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedHabitCategory == category,
                        action: {
                            withAnimation {
                                selectedHabitCategory = category
                            }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Habit List Placeholder
    
    private var habitListPlaceholder: some View {
        VStack(spacing: 20) {
            ContentUnavailableView(
                "习惯系统开发中",
                systemImage: "checkmark.circle.fill",
                description: Text("用于追踪和管理日常习惯养成\n\n功能规划：\n• 习惯打卡与连续记录\n• 习惯分类与标签管理\n• 统计数据与可视化\n• 提醒与激励机制")
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// 个人档案视图
struct PersonalProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // TODO: 实现个人档案详细内容
                    // 包括：资金储备、核心技能、行业经验、人脉网络、学习偏好等
                    ContentUnavailableView(
                        "个人档案开发中",
                        systemImage: "person.fill",
                        description: Text("展示你的核心竞争力和发展历程\n\n功能规划：\n• 资金储备与目标追踪\n• 核心技能树\n• 行业经验与人脉\n• 学习偏好与成长路径")
                    )
                }
                .padding()
            }
            .navigationTitle("个人档案")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
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
