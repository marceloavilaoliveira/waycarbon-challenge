# WayCarbon Challenge - DevOps #

- [Introduction](#introduction)
- [The Challenge](#the-challenge)
- [The Project](#the-project)
- [Operating Instructions](#operating-instructions)
  - [Installing the Tools](#installing-the-tools)
  - [Getting the Repository](#getting-the-repository)
  - [Configuring the Project](#configuring-the-project)
  - [Building the Images](#building-the-images)
  - [Pushing the Images to Repository](#pushing-the-Images-to-Repository)
  - [Provisioning the Infrastructure](#provisioning-the-infrastructure)
- [Known issues](#known-issues)
- [Special Notes](#special-notes)
- [Contact Information](#contact-information)

## Introduction ##

This repository contains a solution for a DevOps challenge proposed in 01/06/23 by the [WayCarbon](https://waycarbon.com/) company.

## The Challenge ##

The full description of the challenge can be find [here](doc/waycarbon-challenge.pdf).

In summary, the challenge is to provision a cloud environment for a web application that consists of a frontend component and a backend component, using one or more Docker containers. The components should be served on the same domain but with different paths. The frontend and backend need to form a cohesive application, with one depending on the other.

## The Project ##

This project is based on [knaopel/docker-frontend-backend-db](https://github.com/knaopel/docker-frontend-backend-db) repository, and consists of 4 services deployed in Docker containers. There is a web app (frontend) that communicates with an API (backend), which in turn reads/writes data to a database (mongo). These services are accessed through a web server (nginx).

The project structure is shown following: 

![Project Structure](doc/project-structure.png)

The project can be seen in all its glory at:

- Frontend: http://waycarbon-challenge.freeddns.org/
- Backend: http://waycarbon-challenge.freeddns.org/api

## Operating Instructions ##

### Installing the Tools ###

To use all the commands and scripts listed here, you need to install and configure the following tools:

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Docker](https://docs.docker.com/engine/install)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Getting the Repository ###

To clone the repository, execute the following:

```bash
$ git clone https://github.com/marceloavilaoliveira/waycarbon-challenge.git
```

These are the repository contents:

```
.
|-- backend/           => Backend component of the web app
|-- frontend/          => Frontend component of the web app
|-- nginx/             => Nginx configuration
|-- data/              => Mongo DB data (ignored by Git)
|-- bash/              => Bash scripts
|-- ansible/           => Ansible playbooks
|-- terraform/         => Terraform infrastructure definition
|-- doc/               => Documentation
|-- docker-compose.yml => Docker compose file
|-- .env               => Environment definition file
|-- .dockerignore      => Docker ignored files/directories
|-- .gitignore         => Git ignored files/directories
`-- README.md          => This file
```

### Configuring the Project ###

The frontend and backend Docker images are pushed to the `waycarbon-challenge-frontend` and `waycarbon-challenge-backend` repositories on Docker Hub. You need to put the Docker Hub info in the `.env` file at the root of the repository:

```
DOCKER_HUB_USER=<docker-hub-username>
```

This information will be used to create the necessary repositories, push the generated images, and also pull the required images.


### Building the Images ###

To build the Docker images for both the frontend and the backend execute the following:

```bash
$ bash/build.sh
```

If you need to build just a specific component, you can specify it using the -c flag:

```bash
$ bash/build.sh -c frontend|backend
```

### Pushing the Images to Repository ###

To push the Docker images to Docker Hub repository for both the frontend and the backend execute the following:

```bash
$ bash/push.sh
```

If you need to push just a specific component, you can specify it using the -c flag:

```bash
$ bash/build.sh -c frontend|backend
```

The images are pushed to the `$DOCKER_HUB_USER/waycarbon-challenge-frontend` and `$DOCKER_HUB_USER/waycarbon-challenge-backend` repositories on Docker Hub. If these repositories do not exist, the build script will create them. In that case, it requires the Docker Hub password. You can set the following environment variable:

```bash
$ export DOCKER_HUB_PASS=<docker-hub-password>
```

Or you can just answer to the script when it was prompt.

### Provisioning the Infrastructure ###

To provision the infrastructure in AWS execute the following:

```bash
$ cd terraform
$ terraform init
$ terraform apply
```

### Deploying the Project ###

To deploy the project in AWS execute the following:

```bash
$ cd ansible
$ ansible-playbook deploy.yaml
```

## Known issues ##

- This project assumes that the provisioned instance can be accessed at `waycarbon-challenge.freeddns.org`. The [Dynu](https://www.dynu.com/) site is being used for this.

- The Public SSH key used in the provisioned instance is defined in the file `terraform/main.tf` and should be adjusted as needed before provisioning.

- The application data is stored in the `data` directory. It would be more convenient for them to be stored in an independent volume, making backups easier.

## Special Notes ##

*TBD*

## Contact Information ##

Author: **Marcelo Ávila de Oliveira**

- E-mail: [marceloavilaoliveira@gmail.com](marceloavilaoliveira@gmail.com)
- GitHub: [https://github.com/marceloavilaoliveira](https://github.com/marceloavilaoliveira)
- StackOverflow: [https://stackoverflow.com/users/4653675](https://stackoverflow.com/users/4653675)
