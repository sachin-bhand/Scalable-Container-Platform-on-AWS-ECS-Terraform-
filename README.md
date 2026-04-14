# 🚀 Scalable Container Platform on AWS (ECS + Terraform)

## 📌 Overview

This project provisions a **scalable AWS infrastructure using Terraform** and deploys a **containerized application** using **Amazon ECS (EC2 launch type)**.

The workflow:

1. Build app locally
2. Containerize using Docker
3. Push image to Amazon ECR
4. Deploy infrastructure via Terraform
5. Run app on ECS with ALB and RDS backend

---

## 🏗️ Architecture

```id="z4s3g1"
User → ALB → ECS (EC2 via ASG) → Docker Container → RDS
```

---

## ⚙️ Tech Stack

* AWS (ECS, ECR, VPC, ALB, EC2, RDS, IAM)
* Terraform
* Docker / Docker Compose
* Node.js (Sample App)

---

## 📂 Project Structure

```id="1h1y3q"
.
├── app/
│   ├── server.js
│   ├── package.json
│   └── .env
│
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       ├── alb/
│       ├── asg/
│       ├── ecs/
│       ├── rds/
│       ├── iam/
│       ├── ecr/
│       └── security/
```

---

## 🧑‍💻 Sample Application (Node.js)

### `app/server.js`

```javascript
const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('🚀 App is running on ECS!');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

### `app/package.json`

```json
{
  "name": "ecs-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

---

## 🐳 Docker Configuration

### `docker/Dockerfile`

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app/ .

EXPOSE 3000

CMD ["npm", "start"]
```

---

### `docker/docker-compose.yml`

```yaml
version: '3.8'

services:
  app:
    build:
      context: ..
      dockerfile: docker/Dockerfile
    ports:
      - "3000:3000"
    env_file:
      - ../app/.env
```

---

## ▶️ Run Application Locally

```bash
cd docker
docker-compose up --build
```

Access:

```id="x7yzc8"
http://localhost:3000
```

---

## 🐳 Push Image to ECR

```bash
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-south-1.amazonaws.com

docker build -t my-app -f docker/Dockerfile .
docker tag my-app:latest <account-id>.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest
docker push <account-id>.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest
```

---

## 🌍 Deploy Infrastructure (Terraform)

```bash
cd terraform

terraform init
terraform plan
terraform apply
```

---

## 🌐 Access Application

```bash
terraform output
```

Open:

```id="p7y6u9"
http://<alb_dns>
```

---

## 🧹 Cleanup

```bash
terraform destroy
```

---

## ⚠️ Troubleshooting

### App not working locally

* Check `.env` file
* Ensure port 3000 is free

### ECS task failing

* Check logs in CloudWatch
* Verify ECR image URI

### ALB not responding

* Check target group health
* Verify security group rules

---

## 📈 Future Enhancements

* CI/CD pipeline (GitHub Actions / Jenkins)
* HTTPS using ACM
* ECS Fargate migration
* Monitoring (Prometheus + Grafana)
* Auto scaling policies

---

## 👨‍💻 Author

**Sachin Bhand**

---
