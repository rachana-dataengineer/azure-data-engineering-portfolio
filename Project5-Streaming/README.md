# Project 5 — Real-Time Streaming Pipeline

## 🎯 Objective
Build a real-time streaming pipeline that processes 
sales events as they arrive using Azure Event Hubs 
and Stream Analytics. Aggregate sales data every 
1 minute and write results to ADLS gold container.

## 🏗️ Architecture
Python Producer Script

(simulates real sales events)

↓

Azure Event Hubs

(eventhub-rachana2025/sales-events)

↓

Azure Stream Analytics

(asa-rachana2025)

↓

ADLS Gen2 Gold Container

(streaming/YYYY/MM/DD/HH/)

(JSON aggregation files every 1 minute)

## 🛠️ Tools Used
- Python (azure-eventhub library)
- Azure Event Hubs (Basic tier)
- Azure Stream Analytics
- ADLS Gen2
- JSON file format

## 📋 What Was Built
- Python producer: sales_event_producer.py
- Event Hub namespace: eventhub-rachana2025
- Event Hub: sales-events (2 partitions)
- Stream Analytics job: asa-rachana2025
- Input: Event Hubs (sales-events topic)
- Output: ADLS Gen2 gold/streaming/ folder
- Tumbling window query (1 minute aggregations)

## 🔑 Key Concepts Learned
- Batch vs real-time streaming difference
- Event Hubs architecture (namespace, hub, partition)
- Stream Analytics tumbling window queries
- Real-time aggregations per territory
- JSON output format for streaming results
- azure-eventhub Python library

## 📊 Stream Analytics Query
```sql
SELECT
    territory,
    COUNT(*) AS TotalOrders,
    SUM(amount) AS TotalSales,
    AVG(amount) AS AvgSaleAmount,
    System.Timestamp() AS WindowEndTime
INTO [output-gold-streaming]
FROM [input-sales-events]
GROUP BY territory, TumblingWindow(minute, 1)
```

## 📈 Sample Event
```json
{
  "order_id": 45231,
  "product": "Mountain Bike",
  "amount": 1250.50,
  "territory": "Southwest",
  "timestamp": "2026-06-10T14:30:00"
}
```

## 📊 Results
- Python producer sending 1 event per second
- Event Hubs receiving 42+ messages confirmed
- Stream Analytics processing in real-time
- JSON aggregation files appearing every 1 minute
- Results show total orders and sales per territory

## ⚠️ Important
- Stop Stream Analytics job when not in use
- Basic tier Event Hubs does not support Kafka protocol
- Stream Analytics charges per streaming unit per hour
