#!/bin/sh

# Make the script to abort if any command fails
set -e

# Print the commands as it is executed. Useful for debugging
set -x

#cd environments/development
# Terraform init
terraform init -reconfigure -backend-config="backend-config/backend-staging.tfconfig"

terraform fmt --recursive
terraform validate

## Terraform plan
terraform plan -var-file="tfvars/staging.tfvars"
terraform apply -var-file="tfvars/staging.tfvars" -auto-approve
