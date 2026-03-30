# Credentials and Real Deployment Guide (GitHub + Jenkins + AWS)

## 1) GitHub credentials (for source + webhooks)

Where to fill:
1. GitHub repository: create a new repo and push this project
2. GitHub Personal Access Token (classic or fine-grained):
   - Used in Jenkins for private repo checkout and API integration

Jenkins location:
1. Manage Jenkins -> Credentials -> Global -> Add Credentials
2. Kind: Username with password (or Secret text token)
3. ID suggestion: `github-token`
4. Use this ID in Jenkins Git/SCM config if repo is private

## 2) Jenkins test-server SSH credentials

Where to fill:
1. Manage Jenkins -> Credentials -> Global -> Add Credentials
2. Kind: SSH Username with private key
3. ID: `test-server-ssh-key`
4. Username: `ubuntu`
5. Private key: paste key that can SSH into your test VM

Job parameters to fill each run:
1. `REMOTE_HOST` = test VM public IP/DNS
2. `REMOTE_USER` = usually `ubuntu`

## 3) Docker Hub credentials

Where to fill:
1. Local terminal on your machine:
   - `docker login`
2. Jenkins (if you later automate Docker push in Jenkins):
   - Manage Jenkins -> Credentials -> Username with password
   - ID suggestion: `dockerhub-creds`

Runtime values to fill:
1. `DOCKERHUB_USER`
2. `IMAGE_NAME` (default `devops-miniapp`)
3. `TAG` (example `v1`, `v2`)

## 4) AWS credentials and EC2 key

Where to fill:
1. AWS CLI on local machine:
   - `aws configure`
   - Fill Access Key ID, Secret Access Key, region
2. EC2 key pair:
   - Download `.pem` when creating instance
   - Store path in `EC2_KEY_PATH`

Runtime values to fill:
1. `EC2_USER=ubuntu`
2. `EC2_HOST=<ec2-public-ip>`
3. `EC2_KEY_PATH=~/.ssh/<your-keypair>.pem`
4. `IMAGE=<dockerhub-user>/devops-miniapp:<tag>`

## 5) Real deploy sequence (exact order)

1. Push project to GitHub
2. Configure Jenkins pipeline job from SCM path `project1-jenkins/Jenkinsfile`
3. Add webhook `http://<jenkins-ip>:8080/github-webhook/`
4. Run one commit push to trigger Jenkins deployment
5. Build and push docker image:
   - `./project2-docker-ec2/scripts/build_and_push.sh`
6. Deploy image to EC2:
   - `./project2-docker-ec2/scripts/ec2_deploy.sh`
7. Verify:
   - Test VM: `http://<test-vm-ip>:8000/health`
   - EC2 live: `http://<ec2-public-ip>/health`

## 6) What you submit after successful run

1. Repo URL (GitHub)
2. Jenkins pipeline success screenshot + console log screenshot
3. Docker Hub image tag screenshot
4. EC2 running container screenshot (`docker ps`)
5. Browser/curl health screenshot from EC2 public IP
6. Demo video recorded using `docs/demo-recording-runbook.md`
