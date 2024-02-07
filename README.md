# Vegans-Technical-Assignment
Since documentation is crucial for collaboration & maintenance, I`ve created this README.md file to provide documentation for my project, explaining an overview of my infrastructure, instructions on how to deploy it, and any prerequisites for using my Terraform configuration as well.


Test/Project:
=============
This repository is for deploying a Java MicroService with REST API that is:
- Capable of scaling based on traffic
- Deployed via CI/CD
- Protected by a WAF
- Reliant on a MySQL DB


My Architecture/Design:
=======================
I used Terraform as IaC tool to setup this infrastructure. Given the need to minimize operating costs, I considered cost-effective choices like using:
- AWS`s ECS (Elastic Container Service) for hosting the Micro service with auto-scaling capabilities
- AWS`s RDS (Relational Database Service) for MySQL
- AWS`s WAF for protection


Overview & Key Components:
==========================
I described the infrastructure in configuration files/TF Scripts that I can version & reuse, I basically defined the below:
- backend.tf: This configuration file is to manage my Terraform state in a remote location (S3 bucket, with  DynamoDB table for state locking), this is crucial for team environments to ensure state is shared & locked correctly.
- data.tf: For defining data sources that fetch information from my cloud provider or other sources without managing any resources, this allows using information defined outside my Terraform configuration or queried from the runtime environment. Whenever we query existing infrastructure details (e.g., a VPC or subnets), we might reference these data sources in our main.tf.
==> I didn`t really use it in my code, however, I only put an example fetching the default VPC, so that we can reference it in resource definitions instead of hardcoded VPC IDs.
- main.tf: For defining resources blocks, I defined ECS cluster, Task Definition, Service & RDS instance.
- outputs.tf: For specifying output values that I can query to get details about my deployment or use elsewhere.
- providers.tf: Declare my cloud provider (AWS), separating my provider configuration helps clarifying which providers my infrastructure depends on & centralize their configuration, it's especially useful in complex projects that use multiple providers, and keeps "main.tf" cleaner.
- terrafrom.tfvars: For defining values for my variables declared in "variables.tf", I used this file to specify environment-specific values, like AWS region, database credentials, etc...
- variables.tf: For defining variables used in my Terraform configurations.
- .gitignore: To ensure sensitive data or unnecessary files (like .terraform/ directory or .tfstate files) aren't accidentally committed to version control, this file doesn't impact any Terraform configurations directly but is crucial for security & cleanliness as it ensures sensitive files & directories aren't tracked in version control.

Side NOTE:
Since the infrastructure grows in complexity, I prefer to have multiple files & use additional Terraform features for better organization, modularity, and manageability, ensuring that my configuration is modular, secure, and well-documented. As our Terraform project(s) grow, we'll likely refactor our configuration to use some additional files & features to maintain clarity, reusability, and ease of management. It`s always important to align our project structure with the complexity of our infrastructure and the needs of our team.

Future additional Files:
- modules/: For modularization, we might create a modules/ directory where we define reusable pieces of our infrastructure. Each module would have its own set of .tf files, similar to our main configuration.
- security_groups.tf or vpc.tf: For large infrastructures, we might separate resources into their files based on their purpose, like security groups or VPC configurations, for better readability & organization.

Future additional Features:
- Dynamic Blocks: To dynamically configure resources based on input variables or data sources.
- Local Values: Defined in a locals.tf file, locals can simplify repeated expressions or fixed values.
- Workspaces: For managing different states of our infrastructure corresponding to different environments (development, staging, production) without changing the configuration.


Services Used:
==============
- AWS`s Elastic Container Service (ECS) with Fargate: For deploying the Java application in containers, without managing servers, and auto-scaling.
- AWS`s RDS MySQL: Database backend, managed relational database service that supports MySQL, automating setup, operation and scaling.
- AWS`s WAF: Provides web application firewall that helps protect your web applications from common web exploits, to be attached to the ECS load balancer or API Gateway (depends on how the service will be exposed).
- CI/CD with AWS CodePipeline: Since Terraform doesn’t directly handle CI/CD, will need to integrate into CI/CD pipelines for infrastructure deployment. AWS CodePipeline automates the steps required to release my software continously, hence having Continous Integration & Deployment


Implementing CI/CD:
===================
- Source Stage: Used GitHub as the source repository for the MicroService code (Could have been AWS CodeCommit as well).
- Build Stage: Used AWS CodeBuild to compile the Java code, run tests & package it.
- Deploy Stage: Automatically deploy the changes to ECS through AWS CodePipeline, which triggers Terraform for infrastructure changes.


Considerations for Cost Minimization:
=====================================
- Use AWS Free Tier resources where possible
- Optimize instance sizes based on load, better to start small & scale as needed
- Consider using Spot instances for the ECS tasks
- Monitor & adjust auto-scaling policies to ensure we’re scaling efficiently
- Regularly review AWS Cost Explorer to identify & reduce unnecessary expenses


Terraform Deployment (Step-By-Step Logic):
==========================================
- Step #1: Setup Terraform - Ensure Terraform is installed & configured for the AWS account, will need an AWS access key ID & secret access key for Terraform to manage resources.
- Step #2: Define the Terraform Configuration - Create a set of Terraform configuration files to define the required infrastructure.
- Step #3: Networking Resources - Define VPC, subnets & other networking resources.
- Step #4: ECS Cluster & Service - Define ECS cluster & a service	to run the Java application container, this includes defining a task definition with the container image & resources.
- Step #5: RDS MySQL Database - Set up RDS instance for MySQL, need to define the instance size, engine version & credentials.
- Step #6: WAF Configuration - Attach a WAF to the load balancer or API Gateway, defining rules to protect against common web exploits. To protect the application with AWS WAF, need to attach a web ACL to the load balancer, thus the WAF setup involves creating a web ACL with rules that define the desired web traffic filtering.
- Step #7: CI/CD Integration - Since Terraform does not directly manage CI/CD processes, then we can integrate into AWS CodeBuild & AWS CodePipeline to automate the deployment process, and of course we have our application code stored in a GitHub repository.


Publishing To A Private Repository:
===================================
I recommend using GitHub, it is a very popular & effective option for storing, sharing, and versioning Terraform files. It offers several advantages, especially for collaboration, version control, integration with various CI/CD tools, and paired with external secrets management solutions, it definetly provides a powerful platform for managing your infrastructure as code.

Advantages of Using GitHub:
- Version Control: GitHub provides robust version control capabilities, allowing to track changes, manage branches, and review history.
- Collaboration: It facilitates collaboration through pull requests & code reviews, making it easier to manage contributions from multiple team members.
- Integration with CI/CD Pipelines: GitHub integrates seamlessly with many CI/CD tools, enabling automated testing, building, and deployment of our infrastructure as code.
- Access Control: GitHub allows us to control who has access to our repositories, enabling us to restrict access to sensitive configurations.

How Did I Use GitHub For Terraform Files?
- Started by creating a new repository on GitHub for my Terraform files, I chose to make this repository public for just the sake of the assesment. However, in Production of course we`ll beed to make it private to restrict access.
- Added my files by cloning the repository to my local machine, added my Terraform configuration files, committed them, and pushed the changes back to GitHub.
- Utilized branches for developing new features or infrastructure changes, used pull requests for merging these changes into the main branch, thus facilitating code review & collaboration.
- Added collaborators.
- Integrated with CI/CD by integrating with AWS CodePipeline to automate the testing & deployment of the infrastructure based on changes in the repository.

Security Considerations - When using GitHub to store Terraform files, especially those that might include sensitive information or are critical to our infrastructure, consider the following:
- Sensitive Information: Never commit sensitive information (e.g., passwords, secret keys) directly into the repository, better to use secrets management tools like AWS Secrets Manager, HashiCorp Vault, or GitHub Secrets for Terraform or GitHub Actions, and reference these secrets in the configurations.
- Repository Visibility: Use private repositories for anything sensitive to limit access to authorized users only.
- Access & Permissions: Regularly review who has access to the repository & apply the principle of least privilege.

Conclusion - Created a robust environment for managing my infrastructure code using GitHub, we can benefit from version control, collaboration tools, automated workflows, and security features to manage access and protect sensitive information. This setup not only streamlines our infrastructure management processes, but also enhances team collaboration & efficiency.


Alternative/Another Design Solution:
====================================
- Use CloudFormation as IaC instead of Terraform
- Use GitHub Actions Workflow for CI/CD instead of AWS CodeBuild & CodePipeline
- Use AWS Elastic Beanstalk Application & Environment instead of ECS (Elastic Container Service)
- Publish the CloudFormation template (or even our TF Scripts) in a private registry, since AWS doesn't have a "private registry" specifically for CloudFormation templates like it does for container images (ECR) or serverless applications (SAR), we can effectively create a private repository for our templates using Amazon S3 & control access using AWS Identity & Access Management (IAM) policies. Terraform files can be securely stored in an S3 bucket, and access can be controlled using AWS Identity & Access Management (IAM) policies or pre-signed URLs. This method allows us to share our Terraform configurations in a private & controlled manner.


Final NOTEs/Thoughts:
=====================
- Define Requirements: Clarify specific requirements for each service, including instance types, database size & expected traffic.
- Develop Terraform TF script(s): Start with basic templates & iterate to include all components.
- Test Deployment: Deploy in a staging environment to test the setup & CI/CD pipeline.
- Monitor & Optimize: After deployment, monitor the application & infrastructure performance, need to make sure to optimize for cost & efficiency (for cost can utilize AWS Cost Managment tools).

For Testing:
- Security Groups & Subnets: Need to define or reference existing security groups & subnets in the AWS account, make sure the security groups allow traffic as needed for application & database.
- Load Balancer: I`m using a load balancer with a target group, will need to define these resources in the Terraform configuration as well, adjusting the "aws_ecs_service" block accordingly.
- IAM Role: The "aws_ecs_task_definition" references an execution role (aws_iam_role.ecs_execution_role.arn) that we need to define separately. This role should have policies attached that allow it to interact with other AWS services as necessary for our application.
- WAF: For WAF, we`ve defined an "aws_wafv2_web_acl" resource and associate it with our load balancer.
- CI/CD: CI/CD integration involved setting up WS CodePipeline and CodeBuild projects, which would manage the deployment of our Terraform configurations & application code.
==> Integrating AWS WAF & a CI/CD pipeline into our Terraform setup enhances security & automation for deploying our Java MicroService.
==> For the OAuthToken in the AWS CodePipeline source stage, we need to provide a GitHub OAuth token that has permissions to access the repository. This token should be stored securely, and should consider using AWS Secrets Manager to manage it within Terraform to enhance security.

This setup gives us a foundational infrastructure for deploying a Java MicroService using AWS ECS and RDS for MySQL, adjustments & expansions will be necessary to fully meet our project's requirements & to ensure security & scalability.


Conclusion:
===========
This setup creates a foundational CI/CD pipeline that automates the process of building our Java application from source code in GitHub, building the application with AWS CodeBuild, and deploying it to an ECS service. The AWS WAF integration adds a layer of security by filtering web traffic according to the rules defined in the web ACL.
