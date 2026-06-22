import json
import random
import time
from datetime import datetime
from azure.eventhub import EventHubProducerClient, EventData

# Event Hubs connection details
CONNECTION_STRING = "YOUR_EVENT_HUBS_CONNECTION_STRING_HERE"
EVENT_HUB_NAME    = "sales-events"

# Sample data
territories = ["Southwest", "Northwest", "Canada", "Australia", "Central", "Southeast"]
products    = ["Mountain Bike", "Road Bike", "Helmet", "Gloves", "Jersey", "Shorts"]

def generate_sale():
    return {
        "order_id":  random.randint(10000, 99999),
        "product":   random.choice(products),
        "amount":    round(random.uniform(50, 2000), 2),
        "territory": random.choice(territories),
        "timestamp": datetime.utcnow().isoformat()
    }

# Create producer
producer = EventHubProducerClient.from_connection_string(
    conn_str=CONNECTION_STRING,
    eventhub_name=EVENT_HUB_NAME
)

print("Connected to Event Hubs!")
print("Sending events... Press Ctrl+C to stop")

try:
    while True:
        sale = generate_sale()
        batch = producer.create_batch()
        batch.add(EventData(json.dumps(sale)))
        producer.send_batch(batch)
        print(f"Sent: {sale}")
        time.sleep(1)
except KeyboardInterrupt:
    print("Stopping...")
finally:
    producer.close()
    print("Done!")