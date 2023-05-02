#!/bin/sh

# Make the script to abort if any command fails
set -e

# Print the commands as it is executed. Useful for debugging
set -x

#cd environments/development
# Terraform init
terraform init -reconfigure -input=false -backend-config="backend-config/backend-prod.tfconfig"

terraform fmt --recursive
terraform validate

## Terraform plan
terraform plan -var-file="tfvars/production.tfvars"
terraform apply -var-file="tfvars/production.tfvars" -auto-approve
