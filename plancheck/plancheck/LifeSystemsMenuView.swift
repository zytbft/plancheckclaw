import SwiftUI

/// 人生系统菜单 - 展示所有子系统的入口
struct LifeSystemsMenuView: View {
    @State private var selectedSystem: LifeSystemType? = nil
    
    enum LifeSystemType: String, CaseIterable, Identifiable {
        case habit = "习惯系统"
        case checklist = "检查系统"
        case investment = "投资系统"
        case fitness = "健身系统"
        case speech = "演讲系统"
        case english = "英语系统"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .habit: return "📈"
            case .checklist: return "📋"
            case .investment: return "💰"
            case .fitness: return "💪"
            case .speech: return "🎤"
            case .english: return "📚"
            }
        }
        
        var description: String {
            switch self {
            case .habit: return "追踪和管理日常习惯养成"
            case .checklist: return "执行各类检查和审核清单"
            case .investment: return "追踪投资组合和财务分析"
            case .fitness: return "记录训练计划和身体数据"
            case .speech: return "管理演讲素材和练习记录"
            case .english: return "语言学习和进度追踪"
            }
        }
        
        var color: Color {
            switch self {
            case .habit: return .green
            case .checklist: return .blue
            case .investment: return .orange
            case .fitness: return .red
            case .speech: return .purple
            case .english: return .indigo
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(LifeSystemType.allCases) { system in
                        NavigationLink(destination: systemDetailView(for: system)) {
                            VStack(spacing: 16) {
                                // 图标
                                ZStack {
                                    Circle()
                                        .fill(system.color.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                    
                                    Text(system.icon)
                                        .font(.system(size: 40))
                                }
                                
                                // 标题和描述
                                VStack(spacing: 8) {
                                    Text(system.rawValue)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(system.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(16)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color(NSColor.windowBackgroundColor))
            .navigationTitle("🎯 人生系统")
        }
    }
    
    @ViewBuilder
    private func systemDetailView(for system: LifeSystemType) -> some View {
        switch system {
        case .habit:
            HabitSystemView()
        case .checklist:
            ChecklistSystemView()
        case .investment:
            InvestmentSystemView()
        case .fitness:
            FitnessSystemView()
        case .speech:
            SpeechSystemView()
        case .english:
            EnglishSystemView()
        }
    }
}

#Preview {
    LifeSystemsMenuView()
}
