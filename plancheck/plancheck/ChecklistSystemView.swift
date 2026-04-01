import SwiftUI

/// 检查系统 - 用于执行各类检查和审核清单
/// 
/// 📚 需求来源：docs/01-需求/00人生系统需求/02检查系统.docx
/// 
/// 核心功能规划：
/// - 费曼方法检查清单（简化、教学、复习、多角度解释）
/// - 艾宾浩斯复习提醒（关键节点：1 天、2 天、4 天、7 天、15 天）
/// - 穷查理宝典每日践行清单（多元思维、逆向思维、双轨分析）
/// - 标准化检查清单模板
/// - 自定义检查项目
/// - 完成记录与历史追踪
/// - 智能提醒与重复执行
struct ChecklistSystemView: View {
    @State private var selectedChecklistType: ChecklistType = .all
    @State private var showingCreateChecklist = false
    @State private var showingFeynmanGuide = false
    
    enum ChecklistType: String, CaseIterable {
        case all = "全部"
        case daily = "每日检查"
        case weekly = "每周审核"
        case monthly = "每月复盘"
        case project = "项目检查"
        case travel = "出行清单"
        case feynman = "费曼方法"
        case ebbinghaus = "艾宾浩斯"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 费曼方法快速指南卡片
                feynmanQuickGuide
                
                // 检查清单分类选择器
                categorySelector
                
                // 检查清单列表（TODO: 后续实现）
                checklistListPlaceholder
            }
            .padding()
            .navigationTitle("📋 检查系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: { showingFeynmanGuide = true }) {
                            Label("费曼方法", systemImage: "lightbulb.fill")
                        }
                        Button(action: { showingCreateChecklist = true }) {
                            Label("创建清单", systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingCreateChecklist) {
                CreateChecklistPlaceholderView()
            }
            .sheet(isPresented: $showingFeynmanGuide) {
                FeynmanMethodGuideView()
            }
        }
    }
    
    // MARK: - Feynman Quick Guide
    
    private var feynmanQuickGuide: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("💡 费曼学习方法")
                    .font(.headline)
                Spacer()
                Button(action: { showingFeynmanGuide = true }) {
                    Image(systemName: "info.circle")
                }
            }
            
            HStack(spacing: 16) {
                FeynmanStepCard(
                    step: 1,
                    icon: "book.open",
                    title: "简化",
                    description: "用最简单的语言解释概念"
                )
                
                FeynmanStepCard(
                    step: 2,
                    icon: "person.2.wave.2",
                    title: "教学",
                    description: "尝试教会别人理解"
                )
                
                FeynmanStepCard(
                    step: 3,
                    icon: "arrow.triangle.2.circlepath",
                    title: "复习",
                    description: "回顾卡点重新学习"
                )
                
                FeynmanStepCard(
                    step: 4,
                    icon: "sparkles",
                    title: "玩耍",
                    description: "多角度解释应用"
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
                ForEach(ChecklistType.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedChecklistType == category,
                        action: {
                            withAnimation {
                                selectedChecklistType = category
                            }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Checklist List Placeholder
    
    private var checklistListPlaceholder: some View {
        VStack(spacing: 20) {
            ContentUnavailableView(
                "检查系统开发中",
                systemImage: "list.check.clipboard.fill",
                description: Text("用于执行各类检查和审核清单\n\n功能规划：\n• 标准化检查清单模板\n• 自定义检查项目\n• 完成记录与历史追踪\n• 智能提醒与重复执行")
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// 费曼方法指南视图
struct FeynmanMethodGuideView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 简介
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🎯 什么是费曼学习方法？")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("费曼技巧被誉为'世界上最有效的学习方法'，其核心是通过教学来学习。当你能够简单明了地解释一个概念时，你才算是真正理解了它。")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // 四个步骤详解
                    VStack(alignment: .leading, spacing: 16) {
                        Text("📚 四个核心步骤")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        FeynmanDetailStep(
                            step: 1,
                            title: "第一步：选择一个概念",
                            content: "明确你想要学习的概念或主题。写在纸的顶部，然后尽可能详细地写下你所知道的一切。",
                            icon: "bookmark.fill"
                        )
                        
                        FeynmanDetailStep(
                            step: 2,
                            title: "第二步：教给一个孩子",
                            content: "想象你在向一个完全不了解这个领域的人（甚至是一个孩子）解释这个概念。使用最简单的语言，避免专业术语。",
                            icon: "person.crop.child"
                        )
                        
                        FeynmanDetailStep(
                            step: 3,
                            title: "第三步：回顾与重新学习",
                            content: "在解释过程中，你会发现自己的知识盲点。回到原始材料，重新学习这些薄弱环节，直到能够完整解释。",
                            icon: "arrow.counterclockwise"
                        )
                        
                        FeynmanDetailStep(
                            step: 4,
                            title: "第四步：简化与类比",
                            content: "将知识点串联起来，用简洁流畅的语言讲述。尝试使用类比和比喻，让解释更加生动易懂。",
                            icon: "lightbulb.fill"
                        )
                    }
                    
                    Divider()
                    
                    // 艾宾浩斯遗忘曲线
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🧠 艾宾浩斯遗忘曲线")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("德国心理学家艾宾浩斯发现，遗忘在学习之后立即开始，最初速度很快，后来逐渐减慢。")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // 复习时间节点
                        HStack(spacing: 8) {
                            ReviewTimeNode(day: "1 天", color: .red)
                            ReviewTimeNode(day: "2 天", color: .orange)
                            ReviewTimeNode(day: "4 天", color: .yellow)
                            ReviewTimeNode(day: "7 天", color: .green)
                            ReviewTimeNode(day: "15 天", color: .blue)
                        }
                        .padding(.vertical, 12)
                        
                        Text("💡 提示：在这些关键时间节点复习，记忆效果最佳！")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("费曼学习方法")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

/// 费曼详细步骤
struct FeynmanDetailStep: View {
    let step: Int
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                
                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 复习时间节点
struct ReviewTimeNode: View {
    let day: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(day)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

/// 创建清单占位视图
struct CreateChecklistPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "创建清单功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持创建自定义检查清单")
                )
            }
            .padding()
            .navigationTitle("创建清单")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ChecklistSystemView()
}
