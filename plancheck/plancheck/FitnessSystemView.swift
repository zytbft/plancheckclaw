import SwiftUI

/// 健身系统 - 用于记录训练计划和身体数据
/// 
/// 📚 需求来源：docs/01-需求/00人生系统需求/04健身系统.docx
/// 
/// 核心功能规划：
/// - 三阶段训练体系：热身 → 训练 → 放松与冥想
/// - 分阶段训练计划（基础恢复期 1-4 周、增肌减脂期 5-12 周）
/// - 力量训练、有氧训练、组合训练
/// - 身体指标追踪（体重、体脂等）
/// - 进步曲线可视化
/// - 健身视频文案生成（痛点版、趣味版）
struct FitnessSystemView: View {
    @State private var selectedFitnessTab: FitnessTab = .overview
    @State private var showingAddWorkout = false
    @State private var showingWorkoutGuide = false
    
    enum FitnessTab: String, CaseIterable {
        case overview = "总览"
        case workout = "训练计划"
        case bodyData = "身体数据"
        case nutrition = "营养管理"
        case progress = "进步追踪"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 三阶段训练体系快速入口
                threeStageQuickAccess
                
                // 训练阶段选择器
                phaseSelector
                
                // 训练内容（TODO: 后续实现）
                workoutContentPlaceholder
            }
            .padding()
            .navigationTitle("💪 健身系统")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: { showingWorkoutGuide = true }) {
                            Label("训练指南", systemImage: "book.fill")
                        }
                        Button(action: { showingAddWorkout = true }) {
                            Label("添加训练", systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutPlaceholderView()
            }
            .sheet(isPresented: $showingWorkoutGuide) {
                WorkoutGuideView()
            }
        }
    }
    
    // MARK: - Three Stage Quick Access
    
    private var threeStageQuickAccess: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏋️ 三阶段训练体系")
                .font(.headline)
            
            HStack(spacing: 12) {
                StageCard(
                    stage: 1,
                    icon: "flame.fill",
                    title: "热身",
                    exercises: ["转头", "揉肩", "扩胸", "转腰", "踮脚"],
                    color: .orange,
                    duration: "5-10 分钟"
                )
                
                StageCard(
                    stage: 2,
                    icon: "heart.fill",
                    title: "训练",
                    exercises: ["深蹲", "俯卧撑", "弓步", "平板支撑"],
                    color: .red,
                    duration: "30-45 分钟"
                )
                
                StageCard(
                    stage: 3,
                    icon: "sparkles",
                    title: "放松",
                    exercises: ["冥想", "拉伸", "深呼吸"],
                    color: .purple,
                    duration: "10-15 分钟"
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Phase Selector
    
    private var phaseSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📅 训练阶段")
                .font(.headline)
            
            HStack(spacing: 12) {
                PhaseCard(
                    phase: "基础恢复期",
                    weeks: "1-4 周",
                    frequency: "每周 2-3 次",
                    focus: "复合动作",
                    color: .green
                )
                
                PhaseCard(
                    phase: "增肌减脂期",
                    weeks: "5-12 周",
                    frequency: "每周 3-4 次",
                    focus: "分化训练 + HIIT",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Workout Content Placeholder
    
    private var workoutContentPlaceholder: some View {
        VStack(spacing: 20) {
            ContentUnavailableView(
                "健身系统开发中",
                systemImage: "heart.fill",
                description: Text("用于记录训练计划和身体数据\n\n功能规划：\n• 训练计划与动作库\n• 重量/次数/组数记录\n• 身体指标追踪（体重、体脂等）\n• 进步曲线可视化")
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// 阶段卡片
struct StageCard: View {
    let stage: Int
    let icon: String
    let title: String
    let exercises: [String]
    let color: Color
    let duration: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Circle()
                    .fill(color)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text("\(stage)")
                            .font(.caption2)
                            .foregroundColor(.white)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(exercises.prefix(3), id: \.self) { exercise in
                Text("• \(exercise)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(duration)
                .font(.caption2)
                .foregroundColor(color)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 训练阶段卡片
struct PhaseCard: View {
    let phase: String
    let weeks: String
    let frequency: String
    let focus: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 16, height: 16)
                
                Text(phase)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Label(weeks, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label(frequency, systemImage: "repeat")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label(focus, systemImage: "target")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 训练指南视图
struct WorkoutGuideView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 第一阶段
                    PhaseDetailSection(
                        phase: "第一阶段：基础恢复期",
                        weeks: "1-4 周",
                        color: .green,
                        strengthExercises: [
                            "深蹲 - 3 组×8-12 次",
                            "俯卧撑 - 3 组×8-12 次",
                            "弓步 - 3 组×8-12 次",
                            "杠铃/哑铃划船 - 3 组×8-12 次"
                        ],
                        cardio: "每周 2-3 次，每次 20-30 分钟低强度有氧（快走、慢跑、骑行）",
                        tips: "以复合动作为主，高效刺激全身肌肉群。重点是掌握正确动作模式。"
                    )
                    
                    Divider()
                    
                    // 第二阶段
                    PhaseDetailSection(
                        phase: "第二阶段：增肌减脂期",
                        weeks: "5-12 周",
                        color: .blue,
                        strengthExercises: [
                            "周一：胸 + 三头",
                            "周三：背 + 二头",
                            "周五：腿 + 肩",
                            "核心训练：5-10 分钟（卷腹、平板支撑、抬腿）"
                        ],
                        cardio: "每周 2 次 HIIT：30 秒全力冲刺 + 60 秒慢走，重复 8-10 轮",
                        tips: "增加训练频率和强度，尝试分化训练。HIIT 对燃烧内脏脂肪效果极佳。"
                    )
                    
                    Divider()
                    
                    // 热身动作详解
                    WarmupDetailSection()
                    
                    Divider()
                    
                    // 训练动作详解
                    WorkoutDetailSection()
                    
                    Divider()
                    
                    // 放松与冥想
                    CooldownDetailSection()
                }
                .padding()
            }
            .navigationTitle("训练指南")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

/// 阶段详情
struct PhaseDetailSection: View {
    let phase: String
    let weeks: String
    let color: Color
    let strengthExercises: [String]
    let cardio: String
    let tips: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(phase)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(weeks)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .foregroundColor(color)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("💪 力量训练")
                    .font(.headline)
                
                ForEach(strengthExercises, id: \.self) { exercise in
                    Label(exercise, systemImage: "checkmark.circle.fill")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("🏃 有氧训练")
                    .font(.headline)
                
                Text(cardio)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("💡 提示")
                    .font(.headline)
                
                Text(tips)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 热身动作详情
struct WarmupDetailSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🔥 热身动作（必做！）")
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                WarmupExerciseRow(name: "转头")
                WarmupExerciseRow(name: "揉肩")
                WarmupExerciseRow(name: "扩胸")
                WarmupExerciseRow(name: "转臂")
                WarmupExerciseRow(name: "左右转腰")
                WarmupExerciseRow(name: "转膝")
                WarmupExerciseRow(name: "踮脚")
                WarmupExerciseRow(name: "弓步")
                WarmupExerciseRow(name: "压腿")
                WarmupExerciseRow(name: "下摆臂")
            }
            
            Text("每个动作 8-12 次，总共 5-10 分钟")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 热身动作行
struct WarmupExerciseRow: View {
    let name: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.orange)
                .frame(width: 8, height: 8)
            
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

/// 训练动作详情
struct WorkoutDetailSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏋️ 训练动作库")
                .font(.title3)
                .fontWeight(.semibold)
            
            GroupBox("力量训练") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    WorkoutExerciseRow(name: "深蹲")
                    WorkoutExerciseRow(name: "俯卧撑")
                    WorkoutExerciseRow(name: "弓步")
                    WorkoutExerciseRow(name: "划船")
                    WorkoutExerciseRow(name: "卷腹")
                    WorkoutExerciseRow(name: "平板支撑")
                    WorkoutExerciseRow(name: "马步冲拳")
                    WorkoutExerciseRow(name: "举重")
                }
            }
            
            GroupBox("有氧训练") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    WorkoutExerciseRow(name: "慢跑")
                    WorkoutExerciseRow(name: "高抬腿")
                    WorkoutExerciseRow(name: "开合跳")
                    WorkoutExerciseRow(name: "登山跑")
                    WorkoutExerciseRow(name: "冲刺跑")
                }
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 训练动作行
struct WorkoutExerciseRow: View {
    let name: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
            
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

/// 放松与冥想详情
struct CooldownDetailSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🧘 放松与冥想（必做！）")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                CooldownStep(number: 1, title: "舌抵上腭", description: "促进唾液分泌，安神定志")
                CooldownStep(number: 2, title: "从头到脚依次放松", description: "逐步释放每个部位的紧张")
                CooldownStep(number: 3, title: "大小周天", description: "引导气息循环全身")
                CooldownStep(number: 4, title: "远望练习", description: "绿色草原、天边云端、树叶脉络")
                CooldownStep(number: 5, title: "揉眉扣命", description: "揉眉骨、叩命门穴 32 下")
                CooldownStep(number: 6, title: "咽唾液入丹田", description: "观想金液进入丹田")
            }
            
            Text("总共 10-15 分钟，帮助身体恢复和整合训练效果")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(12)
    }
}

/// 放松步骤
struct CooldownStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number).")
                .font(.headline)
                .foregroundColor(.purple)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// 添加训练占位视图
struct AddWorkoutPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ContentUnavailableView(
                    "添加训练功能开发中",
                    systemImage: "plus.circle.fill",
                    description: Text("即将支持记录训练内容和身体数据")
                )
            }
            .padding()
            .navigationTitle("添加训练")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    FitnessSystemView()
}
