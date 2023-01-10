# Kafka Cluster in AWS

This repository is to deploy a Kafka cluster with Terraform and Ansible in Amazon Web Services(AWS) using Docker.
There are some steps that still require manual interaction, however, this can be changed in the future to be fully automated.
The following [tutorial](https://github.com/mlomboglia/kafka-cluster-infra) was used. Please read it for more insformation.

# Set up

1) Go to AWS and generate a key-pair(login) if you don't have one. It will be used to connect to the EC2 instances.
    Download the `your-key.pem`file.

2) Clone the repository using:
    `git clone xxx`

3) Rename the `your-key.pem` to `kafka-key.pem` and place it in the `secrets`directory.

4) Fill out the `env.list` file with your AWS [access keys](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).

5) Check the `terraform/variables.tf` file and modify the variables according to your needs. **Note:**Kafka needs at least 7GiB of memory to be installed. For this reason `t2.large` instances are used, **this will cost you money**.

# Running the container
The container will prepare the environment for you. It will install Python, Ansible, Terraform and other tools like OpenSSH-client.
It will also mount the files, so any file changes will also be updated in the container.

1) Build the Dockerfile:
    `docker build -t terraform-img .`

2) Start the container:
    `docker run -it -v $(pwd)/:/kafka-mvp --rm --name terraform-container --env-file secrets/env.list terraform-img /bin/bash`

3) Once inside the container we start Terraform
    `cd terraform && terraform init`

4) We look at the plan from terraform 
    `terraform plan`

5) If you agree with the plan run
    `terraform apply`

After this, Terraform will deploy seven `Ubuntu 18 t2.large` instances with the initial configuration.

# Installing Kafka with Ansible
To install Kafka using Ansible we are using their [Ansible Collection](https://github.com/confluentinc/cp-ansible). 
The collection is already installed in the container.

1) Modify the `hosts.yml` file with the Public DNS from each instance e.g. `ec2-xx-xx-xx.compute-1.amazonaws.com`. 

2) To check if the connection worked we will ping to each instance
    `ansible -i hosts.yml all -m ping`

3) If successful, start with the installation
    `ansible-playbook -i hosts.yml confluent.platform.all`

# Producer and Consumer
We will test the cluster by sending some data using the `producer.py` and `consumer.py` files.

1) Modify the `client/config.ini` file. Change the Address to your Broker address, do not delete the port.

2) To produce and send data run
    `./producer config.ini`

3) To consume the data 
    `./consumer config.ini`

# Accessing Confluent Control Center
To get the website view of the control center, you need to connect via SSH to the control center instance and forward the port to your localhost like this:

`ssh -L 9092:localhost:9092 ubuntu@ec2-x-x-x.compute-1.amazonaws.com`

Open your web browser and go to `localhost:9092`. You should see the Control Center.



