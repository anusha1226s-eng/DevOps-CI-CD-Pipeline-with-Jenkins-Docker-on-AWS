# Demo Recording Runbook (10-15 minutes total)

You asked for a short recorded screen-share proving commit-to-deployment for both projects. This runbook gives you an easy script to record once.

## Suggested tooling
- Screen recording: OBS Studio or Loom
- Optional terminal recording: asciinema

## Recording Outline
1. Intro (30s)
2. Demo 1 Jenkins pipeline end-to-end (5-7 min)
3. Demo 2 Docker to EC2 end-to-end (5-7 min)
4. Wrap-up and budget summary (1 min)

## Demo 1 script (speak + actions)
1. Show [project1-jenkins/Jenkinsfile](../project1-jenkins/Jenkinsfile)
2. Explain trigger (`githubPush`) and deployment stage
3. Make tiny app change:

```bash
echo "# trigger" >> sample-python-app/README.md
git add sample-python-app/README.md
git commit -m "chore: trigger jenkins deploy demo"
git push origin main
```

4. Open Jenkins job and show running stages
5. Open Jenkins console and highlight:
   - wheel artifact build
   - `scp` transfer
   - remote health check
6. Show final green status
7. SSH test server and run:

```bash
curl http://localhost:8000/health
```

## Demo 2 script (speak + actions)
1. Show [project2-docker-ec2/Dockerfile](../project2-docker-ec2/Dockerfile)
2. Build and push:

```bash
export DOCKERHUB_USER=<your-dockerhub-user>
export IMAGE_NAME=devops-miniapp
export TAG=v2
./project2-docker-ec2/scripts/build_and_push.sh
```

3. Deploy to EC2:

```bash
export EC2_USER=ubuntu
export EC2_HOST=<ec2-public-ip>
export EC2_KEY_PATH=~/.ssh/<your-keypair>.pem
export IMAGE=<your-dockerhub-user>/devops-miniapp:v2
./project2-docker-ec2/scripts/ec2_deploy.sh
```

4. Validate publicly:

```bash
curl http://<ec2-public-ip>/health
```

5. Show Docker Hub tag page and running container on EC2

## What to keep visible during recording
- Left pane: repo files
- Right pane: terminal and Jenkins browser tab
- Zoom into success/failure lines in logs

## Evidence checklist after recording
- One single video file (MP4)
- 6-8 screenshots from both projects
- Git commit hashes used in demo
- URLs/IPs blurred if sharing publicly
