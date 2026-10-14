# kubernetes-terraform-deployment
Kubernetes deployment using Terraform, Docker, and GitHub Actions
## Deployment Verification

The application was deployed to a local Kubernetes cluster created with Kind.

### Validation Results

- Kubernetes Deployment: 2/2 replicas available
- Pod status: Both application pods running and ready
- Service: `python-cicd-demo-service` (ClusterIP)
- Application health endpoint: `/health`
- Health check response: `{"status":"healthy"}`
- Terraform initialization and validation: Successful
- Terraform state: Deployment and Service imported and tracked

### Useful Commands

Check the deployment and pods:

```bash
kubectl get deployment python-cicd-demo
kubectl get pods
kubectl get service python-cicd-demo-service
```

Access the application locally:

```bash
kubectl port-forward service/python-cicd-demo-service 8080:80
```

Open `http://localhost:8080/health` in your browser.

### Terraform

Initialize the provider and validate the configuration:

```bash
terraform init
terraform validate
terraform plan
terraform state list
```

The Deployment and Service are tracked by Terraform. Review any proposed changes before applying them.
