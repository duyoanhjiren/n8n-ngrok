#!/bin/bash                                                                                sngrok.sh                                                                                                  
echo "--------- 🟢 Start Docker compose down  -----------"
sudo -E docker compose down
echo "--------- 🔴 Finish Docker compose down -----------"
echo "--------- 🟢 Start Ngrok setup -----------"
wget -O ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok.tgz -C /usr/local/bin
sudo apt install -y jq
echo "🔴🔴🔴 Please login into ngrok.com and paste your token and static URL here:"
read -p "Token : " token
read -p "Domain : " domain
ngrok config add-authtoken $token
ngrok http --url=$domain 80 > /dev/null &
echo "🔴🔴🔴 Please wait Ngrok to start...."
sleep 8
export EXTERNAL_IP="$(curl http://localhost:4040/api/tunnels | jq ".tunnels[0].public_url")"
echo Got Ngrok URL = $EXTERNAL_IP
echo "--------- 🔴 Finish Ngrok setup -----------"
echo "--------- 🟢 Pull latest n8n image -----------"
sudo docker pull n8nio/n8n:latest
echo "--------- 🔴 Finished pulling n8n image -----------"
echo "--------- 🟢 Start Docker compose up  -----------"
export CURR_DIR=$(pwd)
sudo -E docker compose up -d
echo "--------- 🔴 Finish! Wait a few minutes and test in browser at url $EXTERNAL_IP for n8n UI -----------"
