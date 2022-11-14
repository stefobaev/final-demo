Deploy a Web Application in Docker Container on AWS Using Terraform

This page describes how to deploy a web application in Docker container on AWS using Terraform.

Description

This solution was created to demonstrate how deploying a web application in Docker container by creating a cloud infrastructure on AWS based on "Infrastructure as a code" using Terraform looks like. It consists of a web application, Terraform modules, root Terraform module and configuration files to create infrastructure.

The solution creates AWS infrastructure for development and production environments and CI/CD pipeline according to specified requirements to build and deploy a web application in Docker container on ECS Cluster based on Fargate by every commit to particular git branch ("main").

The repo contains the next components:

    Terraform project
        Web application
        Root Terraform module
        Terraform modules
            S3 Terraform state - Stores a Terraform state
            Elastic container registry - Creates an Elastic container registry (ECR) repository to store Docker images
            Init build - Builds and pushes initial Docker image to ECR repository
            ECS cluster - Creates a VPC and a ECS cluster
            Codebuild - Creates a Codebuild project
    Presentation

Folders and Files
        terraform.tf - Terraform configuration
        variables.tf - Terraform variables
        main.tf - Terraform main file
        outputs.tf - Terraform outputs
    /presentation - presentation of the project
    /app - web application content directory
            Dockerfile - special file, containing script of instructions, to build Docker image
            Makefile - special file, containing shell commands, to build and push Docker image to ECR repository
    /config - configuration directory
            main.tfvars - Contains variable values for main environment
            secrets.tfvars - Contains secrets (Github token) for Github repository (not presented in the repo)
            buildspec.yml - Build SPEC for AWS Codebuild
    /modules - Terraform modules
        s3 - "S3 Terraform state" module directory
        ecr - "Elastic container registry" module directory
        init-build - "Initial build" module directory
        network - "ECS cluster" module directory
        codebuild - "Codebuild" module directory

Implemention
Preparation

    Create an account on AWS
    Install the required version of Terraform, AWS CLI, and Docker
    Download the repo content
    Obtain Github token
    Create secrets.tfvars and add next content "github_oauth_token = YOUR GITHUB TOKEN"
    Change variable values in *.tfvars

Deployment
Initial step

    Add AWS AIM user credentials to ~/.aws/credentials

terraform init
terraform apply -target=module.s3_terraform_state --var-file=./config/main.tfvars

    Uncomment backend "s3" in terraform.tf file
    
###########################
#you can apply all in once#
###########################

terraform init
terraform apply --var-file=./config/main.tfvars --var-file=./config/secrets.tfvars

###########################
#or you can apply separate#
###########################

terraform init
terraform apply -target=module.ecr --var-file=./config/main.tfvars
terraform apply -target=module.init-build --var-file=./config/main.tfvars
terraform apply -target=module.network --var-file=./config/main.tfvars
terraform apply -target=module.codebuild --var-file=./config/main.tfvars --var-file=./config/secrets.tfvars

    Check results
        Go to your AWS account and check created infrastructure resources
        Go to the DNS name created Application Load Balancer and check an information on a web page

    Change app/templates/index.html file in local git directory and push changes to your github repo to branch "main"

    Check results
        Go to your AWS account and check created infrastructure resources
        Go to the DNS name created Application Load Balancer and check an information on a web page


#######################################################################################################################
#################FROM HERE IF YOU HAVE SECOND OR EVERY NEXT BRANCH(environment) FOLLOW BELLOW COMMANDS#################
#######################################################################################################################


Steps for NEXT  environment

    Copy terraform project to your github repo to branch "name" (backend "s3" for "name" in terraform.tf file should be uncommented)

    Delete .terraform, terraform.tfstate, terraform.tfstate.backup, .terraform.lock.hcl files from your local machine

    Comment backend "s3" for "name" in terraform.tf file

    Go to  and run:

terraform init
terraform apply -target=module.s3_terraform_state --var-file=./config/"name".tfvars

    Uncomment backend "s3" for "name" in terraform.tf file

    Go to  and run (use your ./terraform/config/secrets.tfvars file):

terraform init
terraform apply -target=module.ecr --var-file=./config/"name".tfvars
terraform apply -target=module.init-build --var-file=./config/"name.tfvars
terraform apply -target=module.network --var-file=./config/"name".tfvars
terraform apply -target=module.codebuild --var-file=./config/"name.tfvars --var-file=./config/secrets.tfvars

    Check results
        Go to your AWS account and check created infrastructure resources
        Go to the DNS name created Application Load Balancer and check an information on a web page

    Change app/templates/index.html file in local git directory and push changes to your github repo to branch "name"

    Check results
        Go to your AWS account and check created infrastructure resources
        Go to the DNS name created Application Load Balancer and check an information on a web page

Final step

    Delete created infrastructure
