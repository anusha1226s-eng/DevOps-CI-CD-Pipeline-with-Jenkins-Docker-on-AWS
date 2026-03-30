# Your Live Values and Exact Steps

Jenkins server IP: 13.239.40.212
Test server IP: 3.27.208.170

## 1) Jenkins URL and GitHub webhook

Jenkins URL:
http://13.239.40.212:8080

GitHub webhook payload URL:
http://13.239.40.212:8080/github-webhook/

Add webhook in your repo:
https://github.com/Sunnyprabhakar-cmd/devops_project/settings/hooks

## 2) Jenkins credential you must add

In Jenkins:
Manage Jenkins -> Credentials -> Global -> Add Credentials

- Kind: SSH Username with private key
- ID: test-server-ssh-key
- Username: ubuntu
- Private key: key that can SSH into 3.27.208.170

## 3) Test server preparation

From your local machine:
scp -i ~/.ssh/your-key.pem project1-jenkins/scripts/bootstrap_test_server.sh ubuntu@3.27.208.170:/home/ubuntu/
ssh -i ~/.ssh/your-key.pem ubuntu@3.27.208.170 "bash /home/ubuntu/bootstrap_test_server.sh"

## 4) Jenkins pipeline parameters for run

Build with Parameters values:
- REMOTE_HOST = 3.27.208.170
- REMOTE_USER = ubuntu

Then push a tiny commit to trigger webhook:

git add .
git commit -m "chore: trigger jenkins deployment"
git push origin main

## 5) Verify deployment

From your machine:
curl http://3.27.208.170:8000/health

Expected:
{"status":"ok"}

## 6) Screenshot list

- Jenkins stage view (green)
- Jenkins console lines: wheel build, scp copy, health check
- GitHub webhook delivery success
- Test server health output
