# 🚀 Bug 排查快速启动指南

**基于 2026-03-24 深度反思建立的标准作业程序**

---

## ⚡ 25 分钟 Bug 排查流程

### Step 1: 数据验证（5 分钟）

**工具**: `python3 scripts/check_data.py`

```bash
# 快速检查数据文件
cd /Users/zyt/work/mycode/32plancheckCodexLingma
python3 scripts/check_data.py
```

**检查清单**:
- ✅ 总任务数是否合理？
- ✅ 今天的任务是否存在？
- ✅ 任务状态是否正确？
- ✅ createdAt 时间是否是今天？

**决策树**:
```
数据正确吗？
├─ 否 → 检查 addTask/persist 方法
└─ 是 → UI 刷新问题，进入 Step 2
```

---

### Step 2: Git 对比（5 分钟）

**工具**: `./scripts/compare_git.sh path/to/file.swift`

```bash
# 对比历史版本
./scripts/compare_git.sh plancheck/plancheck/TodayView.swift
```

**交互流程**:
1. 脚本显示最近 10 个 commit
2. 输入要对比的 commit hash（或回车使用上一个版本）
3. 查看差异对比
4. **问关键问题**:
   - 为什么以前可以？
   - 是什么引入了问题？
   - 能恢复到简单版本吗？

---

### Step 3: 最小化修改（10 分钟）

**原则**: 删除所有"优化"代码，恢复最简单的历史版本

**操作步骤**:
1. 全局搜索所有引用点
   ```bash
   grep -r "cachedFilteredTasks" . --include="*.swift"
   ```

2. 列出所有需要修改的位置

3. 使用 search_replace 一次性修改

4. **禁止**: 边编译边修改

---

### Step 4: 验证（5 分钟）

**操作**:
```bash
# 编译
./build_tools/final_build.sh

# 重启 App
osascript -e 'tell application "PlanCheck" to quit'
sleep 3
open "/Users/zyt/work/mycode/32plancheckCodexLingma/PlanCheck.app"

# 测试功能
```

**验证清单**:
- ✅ 编译成功（无 error/warning）
- ✅ App 正常启动
- ✅ 功能正常工作
- ✅ 没有引入新问题

---

## 🛠️ 工具箱

### 工具 1: check_data.py

**用途**: 快速验证数据文件

**输出示例**:
```
================================================================================
📊 PlanCheck 数据检查
================================================================================
总任务数：161

按日期分布（最近 7 天）：
  2026-03-24: 2 个任务 ← 今天
  2026-03-23: 12 个任务
  ...

📋 今天的任务 (2 个)：
  1. [追踪 GitHub 的热榜...]
     状态：notStarted  创建时间：07:15:29
  2. [备份需求：今日任务做一个新备份...]
     状态：notStarted  创建时间：03:15:05

================================================================================
✅ 数据文件读取成功
================================================================================
```

---

### 工具 2: compare_git.sh

**用途**: 快速对比 Git 历史

**输出示例**:
```
==================================================
📚 Git 历史记录：plancheck/plancheck/TodayView.swift
==================================================

abc1234 修复 TodayView 缓存 bug
def5678 添加批量操作功能
ghi9012 初始实现 TodayView

请输入要对比的 commit hash（直接回车查看上一个版本）：
> 
使用上一个版本：ghi9012

==================================================
🔍 对比差异：当前 vs ghi9012
==================================================

@@ -62,29 +62,11 @@ struct TodayView: View {
     }
 
     private var filteredTodayTasks: [TaskItem] {
-        // 检查是否需要更新缓存
-        let searchTextChanged = searchState.searchText != lastSearchText
-        let filterChanged = taskFilter != lastTaskFilter
-        let tasksCountChanged = todayTasks.count != cachedFilteredTasks.count
-        
-        if shouldUpdateCache || searchTextChanged || filterChanged || tasksCountChanged {
-            var tasks = filteredTasksByFilter(taskFilter: taskFilter)
-            
-            if !searchState.searchText.isEmpty {
-                tasks = tasks.filter { task in
-                    task.title.localizedCaseInsensitiveContains(searchState.searchText)
-                }
-            }
-            
-            cachedFilteredTasks = tasks
-            lastSearchText = searchState.searchText
-            lastTaskFilter = taskFilter
-            shouldUpdateCache = false
-        }
-        
-        return cachedFilteredTasks
+        switch taskFilter {
+        case .all: return todayTasks
+        case .pending: return todayTasks.filter { $0.status.isPending }
+        ...
+        }
     }

==================================================
💡 提示：
  - 红色 (-) 是历史版本的内容
  - 绿色 (+) 是当前版本的内容
  - 思考：为什么以前可以？是什么引入了问题？
==================================================
```

---

## 🎯 常见场景处理

### 场景 1: UI 上看不到新创建的任务

**标准流程**:
```
1. python3 scripts/check_data.py
   → 数据已保存 → 进入 Step 2

2. ./scripts/compare_git.sh plancheck/plancheck/TodayView.swift
   → 发现多了缓存逻辑 → 进入 Step 3

3. 删除缓存逻辑，恢复简单计算属性
   → 一次性修改所有引用点 → 进入 Step 4

4. ./build_tools/final_build.sh
   → 编译成功 → 重启测试 → ✅ 解决
```

**预计耗时**: 25 分钟

---

### 场景 2: 任务排序不正确

**标准流程**:
```
1. 检查数据 → 排序字段是否正确
2. Git 对比 → sortedTodayTasks 方法
3. 恢复原始排序逻辑
4. 验证
```

---

### 场景 3: 按钮点击没反应

**标准流程**:
```
1. 检查数据 → 按钮状态是否正确
2. Git 对比 → 按钮的 action 绑定
3. 恢复原始事件处理
4. 验证
```

---

## ⚠️ 禁止行为

### ❌ 绝对不要做的事

1. **未查数据就改代码**
   ```bash
   # ❌ 错误：直接打开 Xcode 修改
   # ✅ 正确：先运行 python3 scripts/check_data.py
   ```

2. **不看 Git 历史就猜测**
   ```bash
   # ❌ 错误："可能是时间问题吧..."
   # ✅ 正确：./scripts/compare_git.sh path/to/file
   ```

3. **碎片化修改**
   ```bash
   # ❌ 错误：修改 → 编译失败 → 再修改 → 再失败
   # ✅ 正确：grep 所有引用 → 一次性修改 → 编译一次
   ```

4. **过度优化**
   ```bash
   # ❌ 错误："这里可以加缓存提升性能"
   # ✅ 正确：有性能证据吗？测量过吗？
   ```

---

## 📊 效率指标

### 目标值

| 指标 | 目标 | 实际（改进前） | 改进空间 |
|------|------|----------------|----------|
| Bug 排查耗时 | 25 分钟 | 90 分钟 | 72% ⬇️ |
| 编译次数 | 最多 2 次 | 6+ 次 | 67% ⬇️ |
| Git 对比时机 | 第一个动作 | 第 3 次尝试 | 提前 80% |
| 数据检查率 | 100% | 33% | 3 倍⬆️ |

---

## 🎖️ 成功案例

### 案例 1: TodayView 缓存 Bug（2026-03-24）

**问题**: 今日任务视图创建后不显示

**传统方式**:
- 尝试 1: 修改 createdAt → 失败（30 分钟）
- 尝试 2: 添加缓存检测 → 失败（60 分钟）
- 尝试 3: 对比 Git → 立即解决（5 分钟）
- **总计**: 95 分钟

**新流程**:
- Step 1: 检查数据 → 数据正确（5 分钟）
- Step 2: Git 对比 → 发现缓存问题（5 分钟）
- Step 3: 删除缓存逻辑（10 分钟）
- Step 4: 验证（5 分钟）
- **总计**: 25 分钟 ✅

**节省时间**: 70 分钟（74%）

---

## 🔁 持续改进

### 每周检视

每周五下午回顾：

1. 本周处理了多少 Bug？
2. 有多少遵循了这个流程？
3. 有多少走了弯路？
4. 流程本身有什么可以改进的？

### 每月更新

每月最后一天：

1. 根据本周检视结果更新此文档
2. 添加新的陷阱和应对策略
3. 优化检查清单
4. 更新工具脚本

---

## 📚 相关资源

### 核心文档

- `/docs/INDEX.md` - 核心规范章节
- `/AGENTS_WORKFLOW.md` - 完整工作流
- `/memory/2026-03-24-reflection.md` - 反思日志
- `/reflections/2026-03-24-deep-reflection.md` - 深度报告

### 工具脚本

- `scripts/check_data.py` - 数据检查
- `scripts/compare_git.sh` - Git 对比
- `build_tools/final_build.sh` - 编译构建

---

## ✨ 核心洞察

> **"如果代码看起来复杂，先问自己：'以前的简单版本哪里去了？'"**

这个洞察来自今天的血泪教训。记住它，应用它，传承它。

---

**创建时间**: 2026-03-24 21:00  
**首次执行**: 立即生效  
**下次检视**: 2026-03-31（周五）  
**维护者**: 您和您的 AI 开发伙伴
