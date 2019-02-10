# init-aws

Steps to build for your environment:

# Preparation

Register a domain:

- Register a new domain (suggestion: [Freenom](https://freenom.com/) has free domains)

Create an AWS account:

- Register a new account on AWS
  - On the AWS console, create a new user (IAM > Users > Add user)
    - On "Access type", select "Programatic access" and unselect "AWS Management Console Access". This user will only have programatic access.
    - On the "Set permissions" screen, mark the "AdministratorAccess" checkbox.
    - At the end, you will be provided with an access key.
      - Click on "Show" and take note of the "Access key ID" and "Secret access key". This is the only oportunty you will have to see this information.

# Configuration

- Run `./create_from_scratch`. You will be presented with information to create a secret file.
- Create the file and run it again. This file will do the following:
  - Create a backend in S3
  - Create a DNS domain
  - Create a certificate for the domain
  - Configure a VPC

Configure DNS:

- The `./create_from_scratch` command should output a list of nameservers.
- Go to where you registered your domain (for example Freenom), and set the outputed nameservers there.
