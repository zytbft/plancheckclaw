import Foundation
import Combine

/// 人生目标数据存储器
/// 
/// 使用 UserDefaults 进行持久化，支持 SwiftUI 自动刷新
@MainActor
class GoalTrackerStorage: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var data: GoalTrackerData {
        didSet {
            save()
        }
    }
    
    // MARK: - Constants
    
    private let userDefaultsKey = "goalTrackerData"
    
    // MARK: - Initialization
    
    init() {
        // 从 UserDefaults 加载数据
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                self.data = try decoder.decode(GoalTrackerData.self, from: savedData)
            } catch {
                print("Failed to decode goal tracker data: \(error)")
                self.data = GoalTrackerData()
            }
        } else {
            // 首次使用，创建默认数据（起点 60 万）
            self.data = GoalTrackerData()
        }
    }
    
    // MARK: - Save Method
    
    /// 保存数据到 UserDefaults
    func save() {
        data.lastUpdatedAt = Date()
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(data)
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        } catch {
            print("Failed to encode goal tracker data: \(error)")
        }
    }
    
    // MARK: - Update Methods
    
    /// 更新财富数据
    func updateWealth(_ value: Int) {
        data.currentWealth = max(0, value)  // 不允许负数
        objectWillChange.send()
    }
    
    /// 更新健康评分
    func updateHealth(_ value: Int) {
        data.currentHealth = min(100, max(0, value))  // 限制在 0-100
        objectWillChange.send()
    }
    
    /// 更新成长数据
    func updateGrowth(_ value: Int) {
        data.currentGrowth = max(0, value)
        objectWillChange.send()
    }
    
    /// 更新深度工作天数
    func updateDeepWorkDays(_ value: Int) {
        data.deepWorkDays = max(0, value)
        objectWillChange.send()
    }
    
    /// 更新运动次数
    func updateWorkoutCount(_ value: Int) {
        data.workoutCount = max(0, value)
        objectWillChange.send()
    }
    
    /// 更新睡眠时长
    func updateSleepHours(_ value: Double) {
        data.sleepHours = max(0.0, value)
        objectWillChange.send()
    }
    
    /// 更新投资收益率
    func updateROIRate(_ value: Double) {
        data.roiRate = max(0.0, value)
        objectWillChange.send()
    }
    
    // MARK: - Batch Update
    
    /// 批量更新所有数据
    func updateAll(
        wealth: Int? = nil,
        health: Int? = nil,
        growth: Int? = nil,
        deepWorkDays: Int? = nil,
        workoutCount: Int? = nil,
        sleepHours: Double? = nil,
        roiRate: Double? = nil
    ) {
        if let wealth = wealth { data.currentWealth = max(0, wealth) }
        if let health = health { data.currentHealth = min(100, max(0, health)) }
        if let growth = growth { data.currentGrowth = max(0, growth) }
        if let deepWorkDays = deepWorkDays { data.deepWorkDays = max(0, deepWorkDays) }
        if let workoutCount = workoutCount { data.workoutCount = max(0, workoutCount) }
        if let sleepHours = sleepHours { data.sleepHours = max(0.0, sleepHours) }
        if let roiRate = roiRate { data.roiRate = max(0.0, roiRate) }
        
        objectWillChange.send()
    }
    
    // MARK: - Future Extension Interfaces
    
    /*
     // TODO: 未来版本支持自动统计时启用
     
     /// 自动更新深度工作天数（从 TaskStore 统计）
     func autoUpdateDeepWorkDays(from tasks: [TaskItem]) {
         // 实现逻辑：统计连续完成深度工作任务的天数
         // 暂不实现，等待后续版本
     }
     
     /// 自动更新运动次数（从完成任务中统计）
     func autoUpdateWorkoutCount(from completedTasks: [TaskItem]) {
         // 实现逻辑：统计本周完成的运动类任务
         // 暂不实现，等待后续版本
     }
     */
}
