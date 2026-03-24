#!/usr/bin/env python3
"""
快速检查 PlanCheck 数据文件
用法：python3 scripts/check_data.py
"""

import json
from datetime import datetime, timezone

def check_tasks():
    tasks_file = "/Users/zyt/Library/Application Support/plancheck/tasks.json"
    
    try:
        with open(tasks_file, "r", encoding="utf-8") as f:
            tasks = json.load(f)
        
        print("=" * 80)
        print("📊 PlanCheck 数据检查")
        print("=" * 80)
        print(f"总任务数：{len(tasks)}")
        print()
        
        # 按日期分组
        from collections import defaultdict
        date_groups = defaultdict(list)
        for task in tasks:
            created = task.get("createdAt", "")[:10]
            if created:
                date_groups[created].append(task)
        
        print("按日期分布（最近 7 天）：")
        for date in sorted(date_groups.keys(), reverse=True)[:7]:
            count = len(date_groups[date])
            marker = "← 今天" if date == datetime.now(timezone.utc).strftime('%Y-%m-%d') else ""
            print(f"  {date}: {count}个任务 {marker}")
        
        print()
        today = datetime.now(timezone.utc).strftime('%Y-%m-%d')
        today_tasks = date_groups.get(today, [])
        
        if today_tasks:
            print(f"📋 今天的任务 ({len(today_tasks)}个)：")
            for i, task in enumerate(today_tasks, 1):
                title = task.get("title", "N/A")[:50]
                status = task.get("status", "N/A")
                created = task.get("createdAt", "N/A")[11:19]
                print(f"  {i}. [{title}]")
                print(f"     状态：{status}  创建时间：{created}")
                print()
        else:
            print("⚠️  今天还没有创建任务")
        
        print()
        print("=" * 80)
        print("✅ 数据文件读取成功")
        print("=" * 80)
        
    except FileNotFoundError:
        print(f"❌ 错误：找不到数据文件 {tasks_file}")
        print("请确认 PlanCheck App 已经运行过")
    except json.JSONDecodeError:
        print(f"❌ 错误：数据文件格式不正确")
        print("tasks.json 可能已损坏")
    except Exception as e:
        print(f"❌ 错误：{e}")

if __name__ == "__main__":
    check_tasks()
