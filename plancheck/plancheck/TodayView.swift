struct TodayView: View {
    @EnvironmentObject private var taskStore: TaskStore
    @EnvironmentObject private var searchState: SearchState
    @State private var taskFilter: TodayTaskFilter = .all
    @State private var showingBulkInput = false
    @State private var isEditingMode = false
    @State private var selectedTaskIDs: Set<UUID> = []
    @State private var lastSelectedTaskID: UUID?  // 记录上次选中的任务，用于 Shift+ 点击
    @State private var showingDeleteConfirmation = false
    @State private var showingAbandonConfirmation = false
    @State private var lastDeletedTasks: [DeletedTask] = []
    @State private var lastAbandonedTaskIDs: [UUID] = []
    @State private var showingUndoToast = false
    @State private var undoActionType: UndoActionType = .delete
    @State private var toastCountdown = 10
    @State private var toastTimer: Timer?
    @State private var taskToDeleteID: UUID?  // 单个任务删除时记录 ID
    @State private var showingRemoveFromMyDayConfirmation = false  // 从今日任务移除确认对话框
    @State private var taskToRemoveFromMyDayID: UUID?  // 记录要移除的任务 ID
    @State private var showingCopyToast = false  // 复制成功提示
    @State private var copiedTaskCount = 0  // 复制的任务数量
    @State private var showingPinToast = false  // 置顶成功提示
    @State private var pinnedTaskCount = 0  // 置顶的任务数量
    @State private var isDraggingToSelect = false  // 是否正在拖动选择
    @State private var dragStartIndex: Int?  // 拖动起始位置索引