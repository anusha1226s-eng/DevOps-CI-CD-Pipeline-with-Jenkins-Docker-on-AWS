# Beginner DevOps Mini-Projects (Reusable)

This repository contains two cohesive mini-projects using the same sample Python app:

1. Jenkins CI/CD: GitHub trigger -> build wheel -> deploy to Ubuntu test server
2. Docker to AWS EC2: container build -> push registry -> pull and run on EC2

## Repository structure

- `sample-python-app/` Shared Python web app used in both projects
- `project1-jenkins/` Jenkins pipeline + deployment scripts
- `project2-docker-ec2/` Dockerfile + image/deploy scripts
- `docs/` Step-by-step setup, demo runbook, and presentation notes

## Quick start order

1. Start with `docs/project1-jenkins.md`
2. Then run `docs/project2-docker-ec2.md`
3. Record evidence using `docs/demo-recording-runbook.md`
4. Fill all real credentials using `docs/credentials-and-real-deploy.md`

## Budget-friendly setup (under INR 10,000)

- Jenkins host: small VM or existing local machine
- Test server: 1 small Ubuntu VM
- AWS EC2: free-tier t2.micro/t3.micro
- Docker Hub: free public repo (or low-cost private registry)

Expected monthly demo cost is typically far below INR 10,000 if resources are stopped after demo sessions.
