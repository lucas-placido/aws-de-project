#!/bin/bash
sudo yum update -y
sudo yum install -y postgresql15
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

def generate_random_data(id):
    products = ["Produto A", "Produto B", "Produto C", "Produto D", "Produto E", "Produto F", "Produto G", "Produto H"]
    product = random.choice(products)
    quantity = random.randint(1, 10)
    price_per_unit = round(random.uniform(10.0, 50.0), 2)
    date = (datetime.now() - timedelta(days=random.randint(0, 7))).strftime("%Y-%m-%d")
    return {"id": id, "produto": product, "quantidade": quantity, "preco_unitario": price_per_unit, "data": date}

def generate_streaming_data(client, stream_name):    
    x = 1000
    y = 2001
    while x < y:
        data = generate_random_data(id = x)
        x += 1
        data_json = json.dumps(data)
        response = client.put_record(
            StreamName=stream_name,
            Data=data_json.encode('utf-8'),
            PartitionKey=str(data["id"])
        )
        print(response)
        time.sleep(1)

if __name__ == "__main__":        
    client = boto3.client("kinesis", region_name="us-east-1")
    stream_name = "${stream_name}"
    generate_streaming_data(client=client, stream_name=stream_name)

EOL

# Make the Python script executable
sudo chmod +x script.py

# Run the Python script in the background
python3 script.py > output.txt 2>&1 &