import SwiftUI

/// 投资系统 - 用于追踪投资组合和财务分析
struct InvestmentSystemView: View {
    @State private var selectedPortfolio: PortfolioType = .overview
    @State private var showingAddInvestment = false
    
    enum PortfolioType: String, CaseIterable {
        case overview = "总览"
        case stocks = "股票基金"
        case crypto = "加密货币"
        case realEstate = "房产投资"
        case insurance = "保险理财"
        case analysis = "财务分析"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 占位内容 - 后续迭代实现
                ContentUnavailableView(
                    "投资系统开发中",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("用于追踪投资组合和财务分析\n\n功能规划：\n• 多账户资产管理\n• 实时估值与盈亏分析\n• 资产配置饼图\n• 定投计划与提醒")
                )
            }
            .padding()
            .navigationTitle("💰 投资系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddInvestment = true }) {
                        Label("添加投资", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddInvestment) {
                AddInvestmentPlaceholderView()
            }
        }
    }
}

/// 添加投资占位视图
struct AddInvestmentPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "添加投资功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持记录投资项目和交易")
                )
            }
            .padding()
            .navigationTitle("添加投资")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    InvestmentSystemView()
}
