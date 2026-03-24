#!/bin/bash
# 快速对比 Git 历史
# 用法：./scripts/compare_git.sh path/to/file.swift

if [ -z "$1" ]; then
    echo "用法：./scripts/compare_git.sh path/to/file.swift"
    echo ""
    echo "示例:"
    echo "  ./scripts/compare_git.sh plancheck/plancheck/TodayView.swift"
    exit 1
fi

FILE=$1

echo "=================================================="
echo "📚 Git 历史记录：$FILE"
echo "=================================================="
echo ""

# 显示最近的提交记录
git log --oneline -10 "$FILE"

echo ""
echo "请输入要对比的 commit hash（直接回车查看上一个版本）："
read COMMIT_HASH

if [ -z "$COMMIT_HASH" ]; then
    # 默认使用上一个版本
    COMMIT_HASH=$(git log --oneline -2 "$FILE" | tail -1 | awk '{print $1}')
    echo "使用上一个版本：$COMMIT_HASH"
fi

echo ""
echo "=================================================="
echo "🔍 对比差异：当前 vs $COMMIT_HASH"
echo "=================================================="
echo ""

# 创建临时文件
TEMP_FILE="/tmp/old_$FILE"
mkdir -p "$(dirname "$TEMP_FILE")"

# 导出历史版本
git show "$COMMIT_HASH:$FILE" > "$TEMP_FILE" 2>/dev/null

if [ $? -eq 0 ]; then
    # 对比差异
    diff -u "$TEMP_FILE" "$FILE" | head -100
    
    echo ""
    echo "=================================================="
    echo "💡 提示："
    echo "  - 红色 (-) 是历史版本的内容"
    echo "  - 绿色 (+) 是当前版本的内容"
    echo "  - 思考：为什么以前可以？是什么引入了问题？"
    echo "=================================================="
    
    # 清理
    rm -f "$TEMP_FILE"
else
    echo "❌ 错误：无法获取历史版本"
    echo "请检查 commit hash 是否正确"
fi
