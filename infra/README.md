# Infrastructure Configuration

Example invocation:

```sh
terraform init -backend-config="bucket=bucket_name" -backend-config="key=state_path" -backend-config="dynamodb_table=lock_table" -backend-config="region=your_region"
terraform init -backend-config="backend.example.hcl" # alternative

terraform plan -var="bucket_name=bucket_name" -var="domain=example.com" -var="subdomain=sub.example.com" -out tfplan
terraform plan -var-file="example.tfvars" -out tfplan # alternative
terraform apply tfplan
```
