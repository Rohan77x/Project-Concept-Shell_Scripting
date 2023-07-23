#!/bin/bash

# Check if NGINX is already installed
if [ -f /etc/nginx/nginx.conf ]; then
  echo "NGINX is already installed."
  exit 0
fi

# Install the NGINX package
sudo apt-get update
sudo apt-get install nginx

# Start the NGINX service
sudo systemctl start nginx

# Enable the NGINX service to start at boot
sudo systemctl enable nginx

# Check the status of the NGINX service
sudo systemctl status nginx

# Print a message to the user
echo "NGINX has been successfully installed."
