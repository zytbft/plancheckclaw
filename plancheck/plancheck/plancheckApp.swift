import AppKit
import SwiftUI
import UserNotifications

@main
struct plancheckApp: App {
    @StateObject private var taskStore = TaskStore()
    @StateObject private var fontManager = FontManager.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        NotificationManager.requestAuthorization()
        NotificationManager.scheduleDailyReminders()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskStore)
                .environment(\.fontSize, fontManager.currentFontSize)
                .onAppear {
                    // 恢复上次的窗口尺寸
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        WindowManager.shared.restoreWindowSize()
                    }
                }
        }
        .commands {
            // 移除默认的 newItem 命令，为自定义快捷键腾出空间
            CommandGroup(replacing: .newItem) {}
        }
    }
}

// MARK: - Application Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 注册全局事件监控
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            // 检查是否有文本编辑器获得焦点
            if let firstResponder = NSApp.keyWindow?.firstResponder,
                firstResponder is NSTextView || firstResponder is NSSearchField
            {
                // 文本编辑场景下，仍然允许字体缩放快捷键
                // 检查是否是 Command + =/-/0
                let modifiers = event.modifierFlags.intersection([
                    .command, .shift, .option, .control,
                ])
                let isCommandPressed = modifiers.contains(.command)

                if isCommandPressed && [69, 78, 29].contains(event.keyCode) {
                    // 字体缩放快捷键，需要拦截
                    return self.handleZoomShortcut(event)
                }

                // 其他快捷键正常传递
                return event
            }

            // 非文本编辑场景，检查修饰键
            let modifiers = event.modifierFlags.intersection([.command, .shift, .option, .control])
            let isCommandPressed = modifiers.contains(.command)

            if isCommandPressed {
                return self.handleZoomShortcut(event)
            }

            return event  // 其他事件正常传递
        }
    }

    /// 处理字体缩放快捷键
    private func handleZoomShortcut(_ event: NSEvent) -> NSEvent? {
        switch event.keyCode {
        case 69:  // '=' 键（Command + =）
            FontManager.shared.zoomIn()
            return nil  // 拦截事件

        case 78:  // '-' 键（Command + -）
            FontManager.shared.zoomOut()
            return nil  // 拦截事件

        case 29:  // '0' 键（Command + 0）
            FontManager.shared.resetZoom()
            return nil  // 拦截事件

        default:
            return event
        }
    }
}

enum NotificationManager {
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            if granted {
                print("通知权限已获取")
            } else if let error = error {
                print("通知权限请求失败：\(error.localizedDescription)")
            }
        }
    }

    static func scheduleDailyReminders() {
        let center = UNUserNotificationCenter.current()
        let identifiers = ["morningReminder", "eveningReminder"]
        center.removePendingNotificationRequests(withIdentifiers: identifiers)

        // 早上 8:00 提醒新建今日任务
        var morningComponents = DateComponents()
        morningComponents.hour = 8
        morningComponents.minute = 0
        let morningTrigger = UNCalendarNotificationTrigger(
            dateMatching: morningComponents, repeats: true)
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "📋 规划今日任务"
        morningContent.body = "早上好！请为今天添加任务和预计时长。"
        morningContent.sound = .default
        let morningRequest = UNNotificationRequest(
            identifier: "morningReminder",
            content: morningContent,
            trigger: morningTrigger
        )
        center.add(morningRequest)

        // 晚上 9:30 提醒检查今日任务
        var eveningComponents = DateComponents()
        eveningComponents.hour = 21
        eveningComponents.minute = 30
        let eveningTrigger = UNCalendarNotificationTrigger(
            dateMatching: eveningComponents, repeats: true)
        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "✅ 检查今日任务"
        eveningContent.body = "晚上好！请检查今天任务的完成情况并记录实际时长。"
        eveningContent.sound = .default
        let eveningRequest = UNNotificationRequest(
            identifier: "eveningReminder",
            content: eveningContent,
            trigger: eveningTrigger
        )
        center.add(eveningRequest)
    }
}
