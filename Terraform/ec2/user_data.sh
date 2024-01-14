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
wget raw.githubusercontent.com/lucas-placido/aws-de-project/feature/kinesis-data-stream/script.py

# Make the Python script executable
sudo chmod +x script.py

# Run the Python script in the background
python3 script.py > output.txt 2>&1 &