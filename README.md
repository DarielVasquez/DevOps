# Deploying an App to AWS with Terraform and Ansible

## Objective

The objective of this guide is to deploy an application to a cloud provider (AWS) using Terraform for infrastructure provisioning and Ansible for configuration management.

## Instructions

### 1. AWS Account Setup

- Ensure you have created an AWS account with an IAM user, and obtained its Access Key and Secret Access Key.

### 2. Terraform Setup

- Download Terraform from [here](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform).
- Unzip the files and move the `terraform.exe` to its own folder, e.g., 'Terraform', in the 'Program Files'.
- Add the 'Terraform' folder path to the system's PATH environment variable for easy access.

### 3. AWS CLI Configuration

- Download and install the AWS CLI from [here](https://aws.amazon.com/cli/).
- Configure the AWS user credentials using `aws configure` and provide the Access Key ID, Secret Access Key, and preferred AWS region (e.g., us-east-1).

### 4. Clone the Repository

- Clone this repository containing the Terraform and Ansible configurations.

### 5. Terraform Infrastructure

- Open a terminal and navigate to the repository.
- Run `terraform init` to initialize Terraform.
- Use `terraform apply` to create the AWS infrastructure, including VPC, public subnets, internet gateway, route tables, an Auto Scaling Group (ASG) for dynamic EC2 instances, security group, key pair, and a load balancer.
- Verify the created infrastructure in the AWS Management Console under the 'VPC' and 'EC2' services.

### 6. Ansible Setup

- Install Windows Subsystem for Linux (WSL) to use Ansible since it is not natively available for Windows.
- Open the Ubuntu terminal and set up a username and password.
- Install Ansible in the Ubuntu subsystem using the commands `sudo apt update` and `sudo apt install ansible`.

### 7. Connect Ansible to AWS

- Export AWS credentials in the Ubuntu subsystem using the commands `export AWS_ACCESS_KEY_ID=[key]` and `export AWS_SECRET_ACCESS_KEY=[key]`.

### 8. Configure Ansible

- Copy the 'ansible' folder from the cloned repository to the Ubuntu subsystem and navigate to the 'ansible' folder.
- Copy the 'keypair.pem' file from the 'public_key' folder in the repository to the 'ansible' folder in Ubuntu and set appropriate permissions using `chmod 400 keypair.pem`.
- Obtain the Public IPv4 DNS of the EC2 instances from 'EC2' service in the AWS Management Console and update the 'hosts.ini' file in the 'ansible' folder with the DNS.
  - Example: `ec2-3-81-231-87.compute-1.amazonaws.com ansible_user=ec2-user ansible_ssh_private_key_file=keypair.pem`

### 9. Run Ansible Playbook

- In the 'ansible' folder, run the command `ansible-playbook -i hosts.ini playbook.yml`.
  - It might be necessary to run the command twice to confirm the SSH connections for both instances.
- Ansible will connect to the EC2 instances over SSH, install dependencies, copy the app repository from GitHub, and start the app with PM2.

### 10. Access the App

- After the Ansible playbook completes successfully, access the app on a web browser using the `<DNS or IP>:5000` URL.
  The app should be working properly.

## Challenge Steps

### Step 1

- Create a file named provider.tf.
  - Add the AWS provider with the region set to us-east-1.
- Create a file named vpc.tf.
  - Define the VPC named ChallengeVPC with its CIDR block.
  - Enable DNS hostnames for the VPC.
  - Create two subnets named PublicSubnet1 and PublicSubnet2 with their respective CIDR blocks.
  - Enable the option to map public IP on launch for both subnets.
  - Assign the VPC ID to the subnets.
  - Set the availability zones for the subnets to us-east-1a and us-east-1b.
  - Create an internet gateway and link it to the VPC.
  - Create a route table for the public subnet and associate it with the VPC.
  - Add routes with the CIDR block and the internet gateway ID.
  - Create route table associations for both subnets.

### Step 2

- Create a file named instances.tf.
  - Define two EC2 instances named EC2Instance1 and EC2Instance2.
  - Use the AMI ami-0f34c5ae932e6f0e4 for Amazon Linux.
  - Enable the option to associate a public IP address to true for both instances.
  - Set the instance type to t2.micro.
  - Assign the subnet ID of PublicSubnet1 to EC2Instance1 and PublicSubnet2 to EC2Instance2.
- Create a file named key_pair.tf.
  - Generate a private key with algorithm "RSA" and 4096 bits.
  - Create a key pair and link it to the private key generated above.
  - Add a local file resource to create the keypair.pem public key on the local machine.
- Create a file named autoscaling_group.tf.
  - Define a launch template for the Auto Scaling Group (ASG) with the image ID ami-0f34c5ae932e6f0e4, instance type t2.micro, security group ID, and the key name from the key pair created above.
  - Create an Auto Scaling Group named ASG with the launch template ID created above.
  - Set the minimum size to 2 instances and the maximum size to 4, with a desired capacity of 2.
  - Assign the VPC zone identifier with both PublicSubnet1 and PublicSubnet2.
  - Add a tag for key = 'Name', value = 'ASG', and set it to propagate at launch.

### Step 3

- Create a file named load_balancer.tf.
  - Define a load balancer with the name "LoadBalancer", internal option set to false, and the type as 'application'.
  - Add the two subnets PublicSubnet1 and PublicSubnet2 to the load balancer.
  - Create a target group named "TargetGroup" with port 80, using an HTTP protocol, and assign the VPC ID.
  - Create a load balancer listener with the load balancer ARN (name) and a default action of type 'forward' with the target group ARN of the "TargetGroup".
- Use the command terraform apply to create the cloud infrastructure.

### Step 4

- As Ansible isn't natively available for Windows, install WSL for Ubuntu using the command 'wsl --install'.
- Create a user name and password for the WSL Ubuntu subsystem.
- Install Ansible in the Ubuntu subsystem by running the commands:

  - sudo apt update
  - sudo apt install ansible
  - Create a folder named 'ansible' and navigate to it using cd ansible.

- Copy the 'keypair.pem' file to the Ubuntu subsystem and make it accessible using chmod 400 keypair.pem.
- Create a file named hosts.ini and include the EC2 instances that will be read by Ansible.
  - Format example: 'ec2-3-85-94-188.compute-1.amazonaws.com ansible_user=ec2-user ansible_ssh_private_key_file=keypair.pem'.
- Create a file named playbook.yml with Ansible instructions to follow. These instructions should include connecting to the hosts provided by the hosts.ini file, installing 'gcc-c++' and 'make' as prerequisites, installing Node.js, NPM, PM2, and Git, copying the app repository from GitHub, installing the app dependencies, starting the app with PM2, and adding a startup script in case the instance restarts.
- Run the command ansible-playbook -i hosts.ini playbook.yml to execute the Ansible playbook.
- Access the site on a browser using the <DNS or IP>:5000 URL to check the deployed app.

## Live App

- Sample EC2 instance URLs with the app running:  
  [Link 1](http://ec2-3-81-231-87.compute-1.amazonaws.com:5000)  
  [Link 2](http://ec2-3-85-94-188.compute-1.amazonaws.com:5000)
