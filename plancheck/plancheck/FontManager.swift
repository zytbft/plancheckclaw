import Combine
import SwiftUI

/// 字体管理器 - 负责管理应用全局的字体大小缩放
class FontManager: ObservableObject {
    static let shared = FontManager()

    // 字体大小配置
    private let defaultFontSize: CGFloat = 14.0
    private let minFontSize: CGFloat = 10.0
    private let maxFontSize: CGFloat = 32.0
    private let fontSizeStep: CGFloat = 2.0  // 每次缩放 2pt

    // 当前字体大小（使用 @Published 触发 UI 刷新）
    @Published var currentFontSize: CGFloat {
        didSet {
            // 保存到 UserDefaults
            UserDefaults.standard.set(currentFontSize, forKey: "PlanCheck_FontSize")
        }
    }

    // 字体大小级别（用于显示当前级别）
    var fontSizeLevel: Int {
        Int((currentFontSize - defaultFontSize) / fontSizeStep)
    }

    init() {
        // 从 UserDefaults 恢复上次的字体大小
        let savedSize = UserDefaults.standard.double(forKey: "PlanCheck_FontSize")
        if savedSize > 0 {
            self.currentFontSize = CGFloat(savedSize)
        } else {
            self.currentFontSize = defaultFontSize
        }
    }

    /// 放大字体（Command + =）
    func zoomIn() {
        currentFontSize = min(currentFontSize + fontSizeStep, maxFontSize)
    }

    /// 缩小字体（Command + -）
    func zoomOut() {
        currentFontSize = max(currentFontSize - fontSizeStep, minFontSize)
    }

    /// 重置字体到默认大小（Command + 0）
    func resetZoom() {
        currentFontSize = defaultFontSize
    }

    /// 获取当前字体大小级别的描述
    var fontSizeDescription: String {
        let level = fontSizeLevel
        if level == 0 {
            return "标准"
        } else if level > 0 {
            return "大 \(level)"
        } else {
            return "小 \(-level)"
        }
    }

    /// 根据当前字体大小计算相对大小
    /// - Parameter baseSize: 基础字号
    /// - Returns: 调整后的字号
    func scaledSize(for baseSize: CGFloat = 14.0) -> CGFloat {
        let ratio = currentFontSize / defaultFontSize
        return baseSize * ratio
    }
}

// MARK: - Environment Key for Font Size
struct FontSizeKey: EnvironmentKey {
    static var defaultValue: CGFloat = FontManager.shared.currentFontSize
}

extension EnvironmentValues {
    var fontSize: CGFloat {
        get { self[FontSizeKey.self] }
        set { self[FontSizeKey.self] = newValue }
    }
}

// MARK: - View Extensions for Auto Font Scaling
extension View {
    /// 自动应用当前字体大小的修饰符
    func autoFont(size: CGFloat = 14.0, weight: Font.Weight = .regular) -> some View {
        self.font(.system(size: FontManager.shared.scaledSize(for: size), weight: weight))
    }
}
