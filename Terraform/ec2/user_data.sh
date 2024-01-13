#!/bin/bash
sudo yum update -y
sudo python3 -m ensurepip
sudo pip3 install virtualenv
sudo chown -R $USER /home/
sudo -u ec2-user

cd /home/ec2-user
virtualenv --python="/usr/bin/python3.9" ec2-venv
source ec2-venv/bin/activate
pip3 install boto3

# Create Python script
cat > script.py << EOL
import json
import random
import time
import boto3
from datetime import datetime, timedelta

def generate_random_data():
    products = ["Produto A", "Produto B", "Produto C", "Produto D", "Produto E", "Produto F", "Produto G", "Produto H"]
    product = random.choice(products)
    quantity = random.randint(1, 10)
    price_per_unit = round(random.uniform(10.0, 50.0), 2)
    date = (datetime.now() - timedelta(days=random.randint(0, 7))).strftime("%Y-%m-%d")
    return {"id": str(random.randint(1000, 9999)), "produto": product, "quantidade": quantity, "preco_unitario": price_per_unit, "data": date}

def generate_streaming_data(firehose_client, delivery_stream):
    while True:
        data = generate_random_data()
        data_json = json.dumps(data)
        response = firehose_client.put_record(
            DeliveryStreamName=delivery_stream,
            Record={'Data': data_json.encode('utf-8')}
        )
        print(response)
        time.sleep(1)

if __name__ == "__main__":        
    firehose_client = boto3.client("firehose", region_name="us-east-1")
    delivery_stream = 'firehose-delivery-stream'
    generate_streaming_data(firehose_client=firehose_client, delivery_stream=delivery_stream)
    
EOL

# Make the Python script executable
sudo chmod +x script.py

# Run the Python script in the background
python3 script.py > output.txt 2>&1 &