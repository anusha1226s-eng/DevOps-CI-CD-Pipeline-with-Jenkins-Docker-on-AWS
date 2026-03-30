# Mini-Project 1: Jenkins Pipeline (GitHub -> Build -> Deploy to Test Server)

## Objective
Build a beginner-friendly CI/CD pipeline that:
1. Watches GitHub for commits
2. Builds a Python wheel artifact
3. Transfers artifact to a test Ubuntu server
4. Deploys automatically and reports success/failure in Jenkins

## Architecture (simple)

```text
GitHub Push
   -> Jenkins Webhook Trigger
      -> Build + Light Test
         -> Archive wheel artifact
            -> SCP wheel to test VM
               -> SSH install + restart app
                  -> Health check
```

## Prerequisites
- 1 Jenkins server (Ubuntu, 2 vCPU, 4 GB RAM is enough)
- 1 test server (Ubuntu free-tier VM, public IP)
- GitHub repository containing this workspace
- Jenkins plugins:
  - Pipeline
  - Git
  - GitHub Integration
  - SSH Agent
- Python 3.10+ on Jenkins agent

## Step 1: Prepare test server (one-time)
SSH into test server and run:

```bash
cd /tmp
# copy bootstrap script from repo or paste content
bash bootstrap_test_server.sh
```

If copying from this repo:

```bash
scp -i ~/.ssh/your-key.pem project1-jenkins/scripts/bootstrap_test_server.sh ubuntu@<TEST_SERVER_IP>:/home/ubuntu/
ssh -i ~/.ssh/your-key.pem ubuntu@<TEST_SERVER_IP>
bash /home/ubuntu/bootstrap_test_server.sh
```

## Step 2: Configure Jenkins credentials
In Jenkins UI:
1. Go to Manage Jenkins -> Credentials
2. Add credential type: SSH Username with private key
3. ID: `test-server-ssh-key`
4. Username: `ubuntu`
5. Private key: paste the private key used for test server login

Also add these Jenkins values:
1. Manage Jenkins -> System -> GitHub: add GitHub token credential (for webhook/API integration)
2. Pipeline job -> Build with Parameters:
   - `REMOTE_HOST`: your test server public IP or DNS
   - `REMOTE_USER`: usually `ubuntu`

## Step 3: Create Jenkins pipeline job
1. New Item -> Pipeline
2. Under Pipeline definition choose `Pipeline script from SCM`
3. SCM: `Git`
4. Repository URL: your GitHub repo URL
5. Script Path: `project1-jenkins/Jenkinsfile`

## Step 4: Configure webhook trigger
In GitHub repo:
1. Settings -> Webhooks -> Add webhook
2. Payload URL: `http://<JENKINS_PUBLIC_IP>:8080/github-webhook/`
3. Content type: `application/json`
4. Event: `Just the push event`

In Jenkins job, ensure GitHub webhook trigger is enabled through the Jenkinsfile trigger.

## Step 5: Update target host in pipeline
Use job parameters instead of editing code each run:
- `REMOTE_HOST` = your VM public IP
- `REMOTE_USER` = `ubuntu` (or your server user)

## Step 6: Commit and push to trigger deployment

```bash
git add .
git commit -m "feat: setup jenkins deployment pipeline"
git push origin main
```

Expected Jenkins stage flow:
1. Checkout
2. Build Artifact
3. Light Test
4. Archive Artifact
5. Deploy To Test Server

## What success looks like
- Jenkins build status is green
- Console shows artifact copied by `scp`
- Remote script prints health JSON from `/health`
- Test server responds:

```bash
curl http://<TEST_SERVER_IP>:8000/health
# {"status":"ok"}
```

## What failure looks like
- If `scp` fails: pipeline fails in `Deploy To Test Server`
- If remote install fails: pipeline fails and prints pip/systemd errors
- If health check fails: pipeline fails on `curl --fail`

## Screenshot checklist for your documentation
Capture these screenshots while running once:
1. Jenkins pipeline stage view (all stages green)
2. Jenkins console log lines showing:
   - artifact path
   - `scp` command
   - `curl ... /health` output
3. GitHub webhook delivery marked successful
4. Test server terminal with `systemctl status devops-miniapp` or container fallback logs

## Interview/classroom talking points
- Why artifact-based deployment (wheel) is better than ad-hoc file copy
- Why health check in deployment stage is critical
- Why Jenkins credentials are safer than hardcoded keys
- How failed deployment is surfaced immediately through pipeline status
