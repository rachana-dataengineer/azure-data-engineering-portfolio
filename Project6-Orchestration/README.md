# Project 6 — End-to-End Orchestration + Monitoring

## 🎯 Objective
Build a master orchestration pipeline that chains 
all individual pipelines together and adds monitoring, 
alerting, and success notifications for production-grade 
pipeline management.

## 🏗️ Architecture
Schedule Trigger (2AM daily)

↓

PL_Master_Orchestration

↓

EXEC_IncrementalLoad

(runs PL_Incremental_SalesOrderHeader)

↓

WEB_SendSuccessNotification

(POST request to webhook)

↓

Azure Monitor Alert

(email on pipeline failure)

## 🛠️ Tools Used
- Azure Data Factory (Master Pipeline)
- Execute Pipeline activity
- Web activity (webhook notification)
- Azure Monitor (failure alerts)
- webhook.site (notification endpoint)

## 📋 What Was Built
- Master pipeline: PL_Master_Orchestration
- Execute Pipeline activity: EXEC_IncrementalLoad
- Web activity: WEB_SendSuccessNotification
- Azure Monitor alert rule: Alert-ADF-Pipeline-Failure
- Action group: ag-adf-alerts
- Email notification on pipeline failure
- Retry policy on all activities (2 retries, 30s interval)

## 🔑 Key Concepts Learned
- Master pipeline orchestration pattern
- Execute Pipeline activity (parent-child pipelines)
- Web activity for external notifications
- Azure Monitor alert rules
- Action groups and email notifications
- Retry policies for fault tolerance
- Webhook integration for pipeline events

## 📊 Webhook Notification Payload
```json
{
  "message": "ADF Master Pipeline completed successfully",
  "pipeline": "PL_Master_Orchestration",
  "runId": "173a7c77-9331-4267-8a7b-f19c397bd375",
  "time": "2026-06-11T18:55:43Z"
}
```

## ⚠️ Challenges Faced
- Databricks token scope insufficient for notebook activity
  → Resolved: replaced with Web activity notification
- Trigger parameter validation error
  → Resolved: added default values to dataset parameters

## 📊 Results
- Master pipeline runs successfully end to end
- Webhook confirmed receiving notification payload
- Azure Monitor alert configured for failure emails
- Pipeline verified via webhook.site dashboard
- Source confirmed as azure-data-factory/2.0

