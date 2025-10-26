# Trabalho-de-Infraestrutura
# 🧩 Atividade Avaliativa Prática 01 — Infraestrutura de TI

**Aluno:** Nicolas Alexandrino Da Silva Amorim
**Turma:** 28M4A
**Professor:** Alysson Ramírez de Freitas Santos
**Data:** 26/10/2025

---

## 📘 Objetivo da Atividade

Esta atividade tem como propósito demonstrar conhecimentos práticos de **Infraestrutura de TI**, aplicando conceitos de **Docker, Kubernetes e Terraform**, além de **integração com AWS ou LocalStack**.

### O que foi implementado:

* Criação de uma **API simples em Flask** (Python).
* **Dockerização** da API.
* **Deploy local** em cluster Kubernetes (Minikube ou Kind).
* **Provisionamento de recurso AWS via Terraform** (bucket S3 + usuário IAM).
* **Testes de integração** via Postman/Insomnia.

---

## 🏗️ Estrutura do Projeto

```
infra-prova-pratica/
├── api/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md
```

---

## ⚙️ 1. API (Flask)

A API foi desenvolvida em **Flask**, contendo dois endpoints:

* **GET /** → retorna mensagem e status da API
* **POST /sum** → soma dois números enviados via JSON

### Exemplo:

```bash
curl http://localhost:5000/
curl -X POST http://localhost:5000/sum -H "Content-Type: application/json" -d '{"a":3,"b":4.5}'
```

### Dependências:

```
Flask==2.2.5
```

---

## 🐳 2. Dockerização

### Dockerfile:

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

### Comandos:

```bash
cd api
docker build -t infra-prova-api:latest .
docker run --rm -p 5000:5000 infra-prova-api:latest
```

---

## ☸️ 3. Kubernetes (Minikube ou Kind)

### Manifestos:

**deployment.yaml**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: infra-prova-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: infra-prova-api
  template:
    metadata:
      labels:
        app: infra-prova-api
    spec:
      containers:
      - name: infra-prova-api
        image: infra-prova-api:latest
        ports:
        - containerPort: 5000
```

**service.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: infra-prova-api-svc
spec:
  selector:
    app: infra-prova-api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: NodePort
```

### Deploy:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get svc infra-prova-api-svc
```

**Acesso via Minikube:**

```bash
minikube service infra-prova-api-svc --url
```

---

## ☁️ 4. Terraform — Infraestrutura AWS / LocalStack

Provisiona:

* Bucket S3 (`infra-prova-bucket`)
* Usuário IAM (`infra_prova_user`)

### Comandos:

```bash
cd terraform
terraform init
terraform apply -auto-approve
terraform output
```

### Upload de arquivo:

```bash
aws s3 cp api/app.py s3://<bucket_name>/app.py
```

**Usando LocalStack:**

```bash
aws --endpoint-url=http://localhost:4566 s3 cp api/app.py s3://<bucket_name>/app.py
```

---

## 🧪 5. Testes de Integração

Testes realizados com **Postman/Insomnia**:

* ✅ GET `/` retornou `{"message": "API de teste - Infraestrutura", "status": "ok"}`
* ✅ POST `/sum` retornou soma correta do corpo JSON.

Prints e resultados dos testes estão incluídos na pasta `/prints` (ou anexados no repositório).

---

## 🪣 6. Recursos Criados via Terraform

| Recurso                    | Tipo        | Descrição                                                                    |
| -------------------------- | ----------- | ---------------------------------------------------------------------------- |
| `aws_s3_bucket.app_bucket` | Bucket S3   | Armazenamento de artefatos da aplicação                                      |
| `aws_iam_user.lab_user`    | Usuário IAM | Usuário com permissões limitadas (s3:ListBucket, s3:GetObject, s3:PutObject) |

---

## 📋 7. Entregáveis

✅ Código-fonte completo (API, Docker, Kubernetes, Terraform)
✅ Prints dos comandos executados
✅ Evidência dos testes via Postman/Insomnia
✅ Link do repositório GitHub
---

## ✅ Checklist Final

* [x] API Flask funcional
* [x] Dockerfile criado e imagem testada
* [x] Deploy no Kubernetes (Minikube ou Kind)
* [x] Terraform aplicado com sucesso
* [x] Testes de integração realizados
* [x] Prints e vídeo anexados
* [x] Repositório Git organizado

