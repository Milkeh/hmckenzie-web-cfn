#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install AWS CLI and unzip (ubuntu)
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws s3 cp s3://hmckenzie-private/private-keys/hmckenzie-server /home/ec2-user/.ssh/

# Do some chef pre-work
/bin/mkdir -p /etc/chef
/bin/mkdir -p /var/lib/chef
/bin/mkdir -p /var/log/chef

# Copy down our validation key
aws s3 cp s3://hmckenzie-private/private-keys/hmckenzie-validator.pem /etc/chef/

# Setup hosts file correctly
cat >> "/etc/hosts" << EOF
10.0.0.5    compliance-server compliance-server.automate.com
10.0.0.6    infra-server infra-server.automate.com
10.0.0.7    automate-server automate-server.automate.com
EOF

cd /etc/chef/

# Install chef
curl -L https://omnitruck.chef.io/install.sh | bash || error_exit 'could not install chef'

# Create first-boot.json
cat > "/etc/chef/first-boot.json" << EOF
{
   "run_list" :[
   "role[base]"
   ]
}
EOF

NODE_NAME=-$(curl http://169.254.169.254/latest/meta-data/instance-id)

# Create client.rb
/bin/echo 'log_location     STDOUT' >> /etc/chef/client.rb
/bin/echo -e "chef_server_url  \"https://api.chef.io/organizations/hmckenzie\"" >> /etc/chef/client.rb
/bin/echo -e "validation_client_name \"hmckenzie-validator\"" >> /etc/chef/client.rb
/bin/echo -e "chef_license \"accept\"" >> /etc/chef/client.rb
/bin/echo -e "validation_key \"/etc/chef/hmckenzie-validator.pem\"" >> /etc/chef/client.rb
/bin/echo -e "node_name  \"${NODE_NAME}\"" >> /etc/chef/client.rb

sudo chef-client -j /etc/chef/first-boot.json