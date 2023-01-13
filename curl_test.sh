#!/bin/bash
public_ip=$(aws ec2 describe-instances --instance-ids i-04d362031a121972b --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
while true
do
  STATUS=$(curl -k -s -o /dev/null -w '%{http_code}' https://$public_ip)
  if [ $STATUS -eq 200 ]; then
    echo "Got 200! All done!"
    break
  else
    echo "Got $STATUS :( Not done yet..."
  fi
  sleep 10
done
