#!/bin/bash
sudo yum update -y
sudo python3 -m ensurepip

cd /home/ec2-user

# Create Python script
cat > script.py << EOL
import json
import random
import time
from datetime import datetime, timedelta

def generate_random_data():
    products = ["Produto A", "Produto B", "Produto C", "Produto D", "Produto E", "Produto F", "Produto G", "Produto H"]
    product = random.choice(products)
    quantity = random.randint(1, 10)
    price_per_unit = round(random.uniform(10.0, 50.0), 2)
    date = (datetime.now() - timedelta(days=random.randint(0, 7))).strftime("%Y-%m-%d")
    return {"id": str(random.randint(1000, 9999)), "produto": product, "quantidade": quantity, "preco_unitario": price_per_unit, "data": date}

def generate_streaming_data():
    while True:
        data = generate_random_data()
        data_json = json.dumps(data)
        print(data_json)
        time.sleep(1)  # Aguarda 1 segundo antes de gerar o próximo conjunto de dados

if __name__ == "__main__":
    generate_streaming_data()

EOL

# Make the Python script executable
sudo chmod +x script.py

# Run the Python script in the background
ec2-venv/bin/python3 script.py > output.txt 2>&1 &