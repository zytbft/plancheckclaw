import SwiftUI
import UserNotifications

@main
struct plancheckApp: App {
    @StateObject private var taskStore = TaskStore()

    init() {
        NotificationManager.requestAuthorization()
        NotificationManager.scheduleDailyReminders()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskStore)
        }
    }
}

enum NotificationManager {
    static func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
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
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComponents, repeats: true)
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
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningComponents, repeats: true)
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