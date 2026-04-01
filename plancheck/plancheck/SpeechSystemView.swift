import SwiftUI

/// 演讲系统 - 用于管理演讲素材和练习记录
struct SpeechSystemView: View {
    @State private var selectedSpeechCategory: SpeechCategory = .all
    @State private var showingAddSpeech = false
    
    enum SpeechCategory: String, CaseIterable {
        case all = "全部"
        case material = "素材库"
        case draft = "演讲稿"
        case practice = "练习记录"
        case delivery = "正式演讲"
        case feedback = "反馈改进"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 占位内容 - 后续迭代实现
                ContentUnavailableView(
                    "演讲系统开发中",
                    systemImage: "mic.fill",
                    description: Text("用于管理演讲素材和练习记录\n\n功能规划：\n• 演讲素材卡片管理\n• 演讲稿撰写与版本控制\n• 练习录音与回放分析\n• 时间控制与肢体语言提示")
                )
            }
            .padding()
            .navigationTitle("🎤 演讲系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSpeech = true }) {
                        Label("添加演讲", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSpeech) {
                AddSpeechPlaceholderView()
            }
        }
    }
}

/// 添加演讲占位视图
struct AddSpeechPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "添加演讲功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持创建演讲和管理素材")
                )
            }
            .padding()
            .navigationTitle("添加演讲")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SpeechSystemView()
}
