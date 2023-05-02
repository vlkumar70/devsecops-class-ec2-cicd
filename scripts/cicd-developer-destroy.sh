#!/bin/sh

# Make the script to abort if any command fails
set -e

# Print the commands as it is executed. Useful for debugging
set -x

#cd environments/development
# Terraform init
terraform init -reconfigure -input=false -backend-config="backend-config/backend-local.tfconfig"

terraform fmt --recursive
terraform validate

## Terraform plan
terraform plan -destroy -out=destroy.plan -var-file="tfvars/local.tfvars"
#terraform destroy -var-file="tfvars/local.tfvars" -auto-approve
terraform apply "destroy.plan"