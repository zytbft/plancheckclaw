import AppKit
import SwiftUI

/// 窗口管理器 - 负责管理应用窗口的缩放和尺寸
class WindowManager: ObservableObject {
    static let shared = WindowManager()

    // 窗口尺寸常量
    private let defaultWindowSize = NSSize(width: 1200, height: 800)
    private let minWindowSize = NSSize(width: 800, height: 600)
    private let maxWindowSize = NSSize(width: 2400, height: 1600)
    private let zoomStep: CGFloat = 0.15  // 每次缩放 15%

    // 当前窗口引用
    private var currentWindow: NSWindow? {
        NSApp.windows.first { $0.isKeyWindow }
    }

    /// 放大窗口（Command + =）
    func zoomIn() {
        guard let window = currentWindow else { return }

        let currentFrame = window.frame
        let newWidth = min(currentFrame.width * (1 + zoomStep), maxWindowSize.width)
        let newHeight = min(currentFrame.height * (1 + zoomStep), maxWindowSize.height)

        // 计算新的 frame，保持窗口中心位置不变
        let newX = currentFrame.origin.x - (newWidth - currentFrame.width) / 2
        let newY = currentFrame.origin.y + (newHeight - currentFrame.height) / 2

        let newFrame = NSRect(x: newX, y: newY, width: newWidth, height: newHeight)

        setFrame(newFrame, for: window)
    }

    /// 缩小窗口（Command + -）
    func zoomOut() {
        guard let window = currentWindow else { return }

        let currentFrame = window.frame
        let newWidth = max(currentFrame.width * (1 - zoomStep), minWindowSize.width)
        let newHeight = max(currentFrame.height * (1 - zoomStep), minWindowSize.height)

        // 计算新的 frame，保持窗口中心位置不变
        let newX = currentFrame.origin.x - (newWidth - currentFrame.width) / 2
        let newY = currentFrame.origin.y + (newHeight - currentFrame.height) / 2

        let newFrame = NSRect(x: newX, y: newY, width: newWidth, height: newHeight)

        setFrame(newFrame, for: window)
    }

    /// 重置窗口到默认尺寸（Command + 0）
    func resetZoom() {
        guard let window = currentWindow else { return }

        let currentFrame = window.frame
        let newFrame = NSRect(
            x: currentFrame.origin.x + (currentFrame.width - defaultWindowSize.width) / 2,
            y: currentFrame.origin.y + (currentFrame.height - defaultWindowSize.height) / 2,
            width: defaultWindowSize.width,
            height: defaultWindowSize.height
        )

        setFrame(newFrame, for: window)
    }

    /// 设置窗口 frame（带动画）
    private func setFrame(_ frame: NSRect, for window: NSWindow) {
        // 检查是否超过限制
        let constrainedFrame = constrainFrame(frame)

        window.setFrame(constrainedFrame, display: true, animate: true)

        // 保存窗口尺寸到用户默认设置
        saveWindowSize(constrainedFrame.size)
    }

    /// 约束窗口尺寸在合理范围内
    private func constrainFrame(_ frame: NSRect) -> NSRect {
        let width = max(min(frame.width, maxWindowSize.width), minWindowSize.width)
        let height = max(min(frame.height, maxWindowSize.height), minWindowSize.height)

        return NSRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }

    /// 保存窗口尺寸
    private func saveWindowSize(_ size: NSSize) {
        UserDefaults.standard.set(size.width, forKey: "PlanCheck_WindowWidth")
        UserDefaults.standard.set(size.height, forKey: "PlanCheck_WindowHeight")
    }

    /// 恢复上次关闭时的窗口尺寸
    func restoreWindowSize() {
        guard let window = currentWindow else { return }

        let width = UserDefaults.standard.double(forKey: "PlanCheck_WindowWidth")
        let height = UserDefaults.standard.double(forKey: "PlanCheck_WindowHeight")

        if width > 0 && height > 0 {
            var frame = window.frame
            frame.size.width = width
            frame.size.height = height
            window.setFrame(frame, display: true, animate: false)
        }
    }
}
