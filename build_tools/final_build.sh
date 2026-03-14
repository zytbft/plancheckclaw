#!/bin/bash
# 切换到项目根目录
cd "$(dirname "$0")/.."

set -e

SDK=$(xcrun --show-sdk-path)
OUTPUT="PlanCheck.app"

echo "=== 编译 PlanCheck ==="
rm -rf "$OUTPUT"
mkdir -p "$OUTPUT/Contents/MacOS"
mkdir -p "$OUTPUT/Contents/Resources"

# 编译
echo "正在编译..."
swiftc \
  -sdk "$SDK" \
  -target arm64-apple-macos15.0 \
  -Osize \
  -parse-as-library \
  plancheck/plancheck/TaskContext.swift \
  plancheck/plancheck/TaskProgressStatus.swift \
  plancheck/plancheck/TaskModel.swift \
  plancheck/plancheck/TaskPriorityModels.swift \
  plancheck/plancheck/TaskTemplate.swift \
  plancheck/plancheck/DailyReview.swift \
  plancheck/plancheck/WeeklyReport.swift \
  plancheck/plancheck/AppSettings.swift \
  plancheck/plancheck/TaskAutomationSettings.swift \
  plancheck/plancheck/LLMSettings.swift \
  plancheck/plancheck/PriorityAuditLogger.swift \
  plancheck/plancheck/TaskPriorityService.swift \
  plancheck/plancheck/PriorityInferenceService.swift \
  plancheck/plancheck/AutoReviewService.swift \
  plancheck/plancheck/TaskAutomationService.swift \
  plancheck/plancheck/ICloudSyncService.swift \
  plancheck/plancheck/WeeklyReportExporter.swift \
  plancheck/plancheck/TaskStore.swift \
  plancheck/plancheck/TaskStoreProtocol.swift \
  plancheck/plancheck/TaskStore+Tasks.swift \
  plancheck/plancheck/TaskStore+Reviews.swift \
  plancheck/plancheck/TaskStore+DeletedTasks.swift \
  plancheck/plancheck/TaskStore+Sync.swift \
  plancheck/plancheck/TaskStore+MidnightCarry.swift \
  plancheck/plancheck/KeyboardShortcutsView.swift \
  plancheck/plancheck/ContentView.swift \
  plancheck/plancheck/AllTasksView.swift \
  plancheck/plancheck/TaskRowView.swift \
  plancheck/plancheck/AddTaskView.swift \
  plancheck/plancheck/BulkTaskInputView.swift \
  plancheck/plancheck/CheckTaskView.swift \
  plancheck/plancheck/EditTaskView.swift \
  plancheck/plancheck/EveningReviewSheetView.swift \
  plancheck/plancheck/HistoryView.swift \
  plancheck/plancheck/ImportantView.swift \
  plancheck/plancheck/IncompleteTasksDetailSheetView.swift \
  plancheck/plancheck/SearchBarView.swift \
  plancheck/plancheck/SettingsView.swift \
  plancheck/plancheck/TodayView.swift \
  plancheck/plancheck/TrashView.swift \
  plancheck/plancheck/plancheckApp.swift \
  -o "$OUTPUT/Contents/MacOS/plancheck" \
  -framework SwiftUI \
  -framework Foundation \
  -framework AppKit \
  -framework UserNotifications \
  -framework UniformTypeIdentifiers

# 复制资源文件
echo "复制资源文件..."
cp -r assets/icon/AppIcon.icns "$OUTPUT/Contents/Resources/"

# 创建 Info.plist
echo "创建 Info.plist..."
cat > "$OUTPUT/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>plancheck</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.plancheck.app</string>
    <key>CFBundleName</key>
    <string>PlanCheck</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>15.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ 编译完成：$OUTPUT"
