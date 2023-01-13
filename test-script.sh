#!/bin/bash
sudo amazon-linux-extras install nginx1 -y
sudo mkdir  /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=US/ST=Chicago/L=Texas/O=Global Security/OU=IT Department/CN=localhost"
#sudo cp /tmp/source-files/nginx.conf /etc/nginx
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
sudo systemctl start nginx
printf "<html>\n<head>\n<title>Hello World</title>\n<body>\n<h1>Hello World</h1>\n</body>\n</html>" | sudo tee /usr/share/nginx/html/index.html
sudo sed -i '58s/^#//' /etc/nginx/nginx.conf
sudo sed -i '59s/^#//' /etc/nginx/nginx.conf
sudo sed -i '60s/^#//' /etc/nginx/nginx.conf
sudo sed -i '61s/^#//' /etc/nginx/nginx.conf
sudo sed -i '62s/^#//' /etc/nginx/nginx.conf
sudo sed -i '81s/^#//' /etc/nginx/nginx.conf
sudo sed -i '43i return 301 https://$host$request_uri;' /etc/nginx/nginx.conf
sudo sed -i '81G' /etc/nginx/nginx.conf
sudo sed -i '82i ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;' /etc/nginx/nginx.conf
sudo sed -i '83i ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;' /etc/nginx/nginx.conf
sudo systemctl restart nginx

