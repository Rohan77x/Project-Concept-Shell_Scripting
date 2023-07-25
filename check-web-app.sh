#!/bin/bash

# Set the URL of the web application to check.

WEB_APP_URL="https://www.example.com"

# Set the email address to send alerts to.

ALERT_EMAIL="you@example.com"

# Check the status of the web application.

response=$(curl -s -o /dev/null -w '%{http_code}\n' $WEB_APP_URL)

# If the response is not 200, send an alert.

if [[ $response -ne 200 ]]; then
  echo "Web application is down."
  echo "Sending alert to $ALERT_EMAIL"
  mail -s "Web Application Down" $ALERT_EMAIL
fi
