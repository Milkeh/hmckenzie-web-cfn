#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

aws s3 cp s3://hmckenzie-private/private-keys/hmckenzie-server /home/ec2-user/.ssh/