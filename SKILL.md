---
name: loudy-ai-auto-task
description: |
  自动从 loudy.ai 领取任务、写稿、发布推文并追踪任务状态。使用条件：
  (1) 用户需要先配置 LOUDY_API_KEY 到 TOOLS.md
  (2) 启动任务后会定时查询奖池、接受任务、提交推文、查询支付状态
  (3) 适用于需要自动抢单并完成 X/Twitter 推文任务的场景
---

# Loudy.ai 自动任务 Skill

## 快速开始

1. **配置 API Key**: 在 TOOLS.md 中添加 `LOUDY_API_KEY`
2. **启动任务**: 告诉 AI "帮我去 loudy.ai 接单"
3. **自动执行**: AI 会自动轮询奖池、完成任务、提交推文

## 工作流程

```
1. fetch_earning_pools() → 获取进行中的奖池列表
2. 选择合适的奖池 → 获取详情
3. 写推文 → 发布到 X/Twitter
4. submit_task() → 提交作品链接
5. 定时 check_task_status() → 查询任务是否被接受
   ├─ 超时未接受 → 报告失败
   └─ 已接受 → 定时查询 payment/支付信息
```

## API 接口

### 1. 获取奖池列表
- **URL**: `GET https://api.loudy.ai/app-api/open-api/v1/earning-pools`
- **Header**: `Authorization: Bearer <LOUDY_API_KEY>`

### 2. 获取奖池详情
- **URL**: `GET https://api.loudy.ai/app-api/open-api/v1/earning-pools/{id}`
- **Header**: `Authorization: Bearer <LOUDY_API_KEY>`

### 3. 提交任务
- **URL**: `POST https://api.loudy.ai/app-api/open-api/v1/earning-pool-tasks/submit`
- **Header**: `Authorization: Bearer <LOUDY_API_KEY>`
- **Body**:
```json
{
  "earningPoolId": 123,
  "taskLink": ["https://x.com/xxx/status/123"],
  "languageType": "zh_CN"
}
```

### 4. 查询任务状态
- **URL**: `GET https://api.loudy.ai/app-api/open-api/v1/earning-pool-tasks/{id}`
- **Header**: `Authorization: Bearer <LOUDY_API_KEY>`
- **返回字段**:
  - `taskStatus` - 任务状态
  - `auditStatus` - 审核状态 (0=未审核, 1=通过, 2=拒绝)
  - `taskLinks` - 作品链接

## 脚本说明

### scripts/fetch_pools.py
获取进行中的奖池列表，过滤 Ongoing 状态

### scripts/submit_task.py
提交作品链接到奖池

### scripts/check_task.py
查询任务状态和支付信息

## 注意事项

- 任务有截止时间 (activityEnd)，需在截止前提交
- 提交后需等待审核 (auditStatus)
- 建议设置定时检查间隔为 5-10 分钟
