import SwiftUI

/// 英语系统 - 用于语言学习和进度追踪
struct EnglishSystemView: View {
    @State private var selectedEnglishSkill: EnglishSkill = .overview
    @State private var showingAddLearning = false
    
    enum EnglishSkill: String, CaseIterable {
        case overview = "总览"
        case vocabulary = "词汇积累"
        case listening = "听力训练"
        case speaking = "口语练习"
        case reading = "阅读理解"
        case writing = "写作表达"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 占位内容 - 后续迭代实现
                ContentUnavailableView(
                    "英语系统开发中",
                    systemImage: "book.fill",
                    description: Text("用于语言学习和进度追踪\n\n功能规划：\n• 单词本与艾宾浩斯记忆曲线\n• 听力材料与听写练习\n• 口语录音与发音对比\n• 阅读笔记与写作素材")
                )
            }
            .padding()
            .navigationTitle("📚 英语系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddLearning = true }) {
                        Label("添加学习", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddLearning) {
                AddEnglishLearningPlaceholderView()
            }
        }
    }
}

/// 添加英语学习占位视图
struct AddEnglishLearningPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "添加学习功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持记录英语学习内容")
                )
            }
            .padding()
            .navigationTitle("添加学习")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EnglishSystemView()
}
