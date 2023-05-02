# CICD pipeline of EC2

This project will build the VPC with 9 subnets and create EC2 in public subnet with apache server installation

## Dependencies

```
- terraform v0.13+
- install jq
```
## OIDC setup
```
- Here I am using GitHub OIDC connectivity. This setup will give shorterm creentials using (Amazon STS)
- We need to create one OIDC roles for one repo.. its one-to-one relation
- First you need to have github branch. Make a note of the branch Ex: DevOpsAirflow/devsecops-class-ec2-cicd
- Login to AWS Console
  * go to IAM
  * go to identify provider (give github provider)
  * Add oidc role
  * you need to update this OIDC role in your .github/workflow/*.sh files
```

## Precheck
```
- Make the variables changes to tfvars/*.tfvars files
- Make the backend config changes in backend-config/*.tfconfig files
```
## Commands
```
- https://github.com/DevOpsAirflow/devsecops-class-ec2-cicd.git
- cd devsecops-class-ec2-cicd
- git branch -a
```
### As a developer we need to work on developer-apply branch first
- git checkout <b>developer-apply</b>
- Make changes and commit the code 
  * git status
  * git add .
  * git commit -m "updated and validating"
  * git push origin developer-apply
- This will trigger the .github/workflows/cicd-local-apply.yml
- go to github/Actions and watch the workflow run
- After success validate your changes in development
- Once everything looks good then destroy the resource which you created by merging with <b>developer-destroy</b> branch
  * go to pull Request
  * select New Pull Request
  * select base branch and compare branch correctly
  * in this case.. base: developer-destroy compare: developer-apply
  * put some comment
  * Raise the PR .. someone will review and approve
  * Once its approved you can go ahead and merge with developer-destroy
- this will trigger .github/workflows/cicd-local-destroy.yml
- go to github/Actions and watch the workflow run
- After success validate your changes in development
- Once everything looks good then you can promote your changes to <b>development</b> environment
  * same process is above
- Once everything looks good then you can promote your changes to <b>staging</b> environment
  * same process is above
- Once everything looks good then you can promote your changes to <b>production</b> environment
  * same process is above
- you are done with CICD pipeline


