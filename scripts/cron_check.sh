#!/bin/bash
# loudy.ai 定时检查脚本
# 每5分钟检查一次

export LOUDY_API_KEY="8637aaeb578d4690951736874775cb59"
LOG_FILE="/root/.openclaw/workspace/loudy_tasks.json"
LAST_FILE="/root/.openclaw/workspace/loudy_last.json"

# 获取当前奖池
python3 /usr/lib/node_modules/openclaw/skills/loudy-ai-auto-task/scripts/check_tasks.py > "$LOG_FILE"

# 比较是否有新任务
if [ -f "$LAST_FILE" ]; then
    if diff -q "$LOG_FILE" "$LAST_FILE" > /dev/null 2>&1; then
        # 没有变化
        exit 0
    fi
fi

# 有新任务或首次运行，保存并标记需要通知
cp "$LOG_FILE" "$LAST_FILE"
echo "NEW_TASKS" > /root/.openclaw/workspace/loudy_has_new.txt
