#!/usr/bin/env bash
set -euo pipefail

# Run this once on your Ubuntu test VM.
APP_NAME="devops-miniapp"
APP_DIR="/opt/devops-miniapp"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"

sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip curl
sudo mkdir -p "$APP_DIR/releases"
sudo chown -R "$USER":"$USER" "$APP_DIR"

cat <<EOF | sudo tee "$SERVICE_FILE"
[Unit]
Description=DevOps Mini App Service
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$APP_DIR
ExecStart=$APP_DIR/venv/bin/gunicorn -w 2 -b 0.0.0.0:8000 src.app:app
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable "${APP_NAME}.service"
# Service starts after first deployment when wheel and venv are installed.
