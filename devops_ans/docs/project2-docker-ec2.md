# Mini-Project 2: Container Build -> Registry Push -> EC2 Pull and Run

## Objective
Create an end-to-end container workflow that:
1. Builds Docker image from the same Python app
2. Pushes image to Docker Hub (or private registry)
3. Pulls image on AWS EC2 and runs it live

## Architecture (simple)

```text
Git Commit
   -> docker build
      -> docker push (Docker Hub)
         -> SSH to EC2
            -> docker pull
               -> docker run -p 80:8000
                  -> app live on EC2 public IP
```

## Prerequisites
- AWS account (free-tier)
- EC2 t2.micro or t3.micro Ubuntu instance
- Security group inbound rules:
  - SSH 22 from your IP
  - HTTP 80 from Anywhere (for demo)
- Docker Hub account
- Local machine with Docker and AWS CLI optional

## Credentials map (where to fill what)
1. Docker Hub credentials:
   - Local terminal: run `docker login`
   - Username/password or access token stored in Docker client
2. AWS credentials (optional for CLI provisioning):
   - Local terminal: run `aws configure`
   - Fill Access Key ID, Secret Access Key, region
3. EC2 SSH key pair:
   - Download `.pem` from AWS while creating EC2
   - Use path in `EC2_KEY_PATH` or script arg 3
4. EC2 host:
   - Fill EC2 public IPv4 in `EC2_HOST` or script arg 2

## Step 1: Build and push image
From repo root:

```bash
docker login
chmod +x project2-docker-ec2/scripts/build_and_push.sh
export DOCKERHUB_USER=<your-dockerhub-user>
export IMAGE_NAME=devops-miniapp
export TAG=v1
./project2-docker-ec2/scripts/build_and_push.sh
```

This script:
1. Builds image using [project2-docker-ec2/Dockerfile](../project2-docker-ec2/Dockerfile)
2. Tags image `<DOCKERHUB_USER>/devops-miniapp:v1`
3. Pushes to Docker Hub

## Step 2: Launch EC2 (free-tier)
Minimum recommended:
- AMI: Ubuntu 22.04 LTS
- Instance type: t2.micro (or t3.micro)
- Storage: 8 GB gp3

You can create manually in AWS Console (easiest for beginner demo).

## Step 3: Deploy image on EC2

```bash
chmod +x project2-docker-ec2/scripts/ec2_deploy.sh
export EC2_USER=ubuntu
export EC2_HOST=<ec2-public-ip>
export EC2_KEY_PATH=~/.ssh/<your-keypair>.pem
export IMAGE=<your-dockerhub-user>/devops-miniapp:v1
./project2-docker-ec2/scripts/ec2_deploy.sh
```

Script actions on EC2:
1. Installs Docker if missing
2. Pulls image from Docker Hub
3. Stops existing container if present
4. Starts new container as `devops-miniapp`
5. Checks `/health`

## Step 4: Validate live deployment

```bash
curl http://<ec2-public-ip>/
curl http://<ec2-public-ip>/health
```

Expected response:

```json
{"status":"ok"}
```

## Optional: use private registry instead of Docker Hub
- Replace image name with your private registry path
- Login on EC2 before `docker pull`
- Keep script structure unchanged

## Screenshot checklist for your documentation
1. Terminal showing successful `docker build` and `docker push`
2. Docker Hub repository page with `v1` tag
3. EC2 terminal showing `docker ps` with running container
4. Browser or curl response from `http://<EC2_PUBLIC_IP>/health`

## Interview/classroom talking points
- Immutable deployment: each version is an image tag
- Why pulling from registry is safer than copying random files
- How rollback works: redeploy previous image tag
- Why security groups and least-open ports matter
