#!/usr/bin/env bash
set -euo pipefail

# Example usage:
# export EC2_USER=ubuntu
# export EC2_HOST=3.111.22.33
# export EC2_KEY_PATH=~/.ssh/devops-aws.pem
# export IMAGE=yourdockerhubuser/devops-miniapp:v1
# ./project2-docker-ec2/scripts/ec2_deploy.sh
# or pass as args:
# ./project2-docker-ec2/scripts/ec2_deploy.sh ubuntu 3.111.22.33 ~/.ssh/devops-aws.pem yourdockerhubuser/devops-miniapp:v1
EC2_USER="${1:-${EC2_USER:-}}"
EC2_HOST="${2:-${EC2_HOST:-}}"
EC2_KEY_PATH="${3:-${EC2_KEY_PATH:-}}"
IMAGE="${4:-${IMAGE:-}}"

if [[ -z "$EC2_USER" || -z "$EC2_HOST" || -z "$EC2_KEY_PATH" || -z "$IMAGE" ]]; then
  echo "Usage: $0 <ec2-user> <ec2-host> <path-to-key.pem> <image>"
  echo "Or set EC2_USER, EC2_HOST, EC2_KEY_PATH, IMAGE as environment variables."
  exit 1
fi

ssh -i "$EC2_KEY_PATH" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" "bash -s" <<EOF
set -euo pipefail

# Install Docker once (idempotent enough for beginner lab use).
if ! command -v docker >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y docker.io
  sudo systemctl enable docker
  sudo systemctl start docker
fi

sudo docker pull $IMAGE
sudo docker rm -f devops-miniapp || true
sudo docker run -d --name devops-miniapp -p 80:8000 --restart unless-stopped $IMAGE
sudo docker ps --filter name=devops-miniapp
curl --fail --silent --show-error http://localhost/health
EOF

echo "EC2 deployment completed for image: $IMAGE"
