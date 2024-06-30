# KoalaBot Infrastructure
Terraform for deployment of KoalaBot on Oracle Cloud Infrastructure

This utilizes the free tier of OCI & HCP Terraform.

## Execute
```bash
terraform login
terraform workspace select development
terraform plan
terraform apply
```

## Workspaces
- development
- production

## Ideas / To Do
- Reserved Public IP (Free)
- Move to Ampere when available
- Wireguard for API/DB
- DB TLS
- Cloudflare DNS
- AWS S3/ Lambda setup