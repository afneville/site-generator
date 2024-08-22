# Infrastructure Configuration

This terraform module will create the resources required to deploy the
site, namely an S3 bucket, DNS records, TLS certificate and CloudFront
distribution. I am using the S3 back end with DynamoDB state locking for
state management and ongoing configuration of the infrastructure. To
initialise and apply, pass variables and back-end configuration with
command line arguments, environment variables or a variable /
configuration file:

```sh
terraform init -backend-config="bucket=bucket_name" -backend-config="key=state_path" -backend-config="dynamodb_table=lock_table" -backend-config="region=your_region"
terraform plan -var="bucket_name=bucket_name" -var="domain=example.com" -var="subdomain=sub.example.com" -out tfplan
terraform apply tfplan
```
