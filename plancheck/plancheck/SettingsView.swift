import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var taskStore: TaskStore
    
    var body: some View {
        NavigationStack {
            Form {
                Section("通用设置") {
                    Toggle("启用通知", isOn: .constant(true))
                    Toggle("午夜自动结转", isOn: .constant(true))
                }
                
                Section("数据") {
                    Button("导出数据") {
                        // TODO: Export data
                    }
                    
                    Button("导入数据") {
                        // TODO: Import data
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}
