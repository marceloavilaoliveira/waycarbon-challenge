# WayCarbon Challenge - DevOps #

- [Introduction](#introduction)
- [The Challenge](#the-challenge)
- [The Project](#the-project)
- [The Challenge](#the-challenge)
- [The Repository](#the-repository)
- [Operating Instructions](#operating-instructions)
  - [Installing the Tools](#installing-the-tools)
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

The final result of the project can be seen running at:

- Frontend: http://waycarbon-challenge.freeddns.org/
- Backend: http://waycarbon-challenge.freeddns.org/api

## The Repository ##

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

## Operating Instructions ##

### Installing the Tools ###

To use all the commands and scripts listed here, you need to have installed the following tools:

- [Docker](https://docs.docker.com/engine/install/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

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

### Provisioning the Infrastructure ###

To provision the infrastructure in AWS execute the following:

```bash
$ cd terraform
$ terraform init
$ terraform apply
```
## Known issues ##

TBD

## Special Notes ##

TBD

## Contact Information ##

- Author: Marcelo Ávila de Oliveira
- E-mail: [marceloavilaoliveira@gmail.com](marceloavilaoliveira@gmail.com)
- GitHub: [https://github.com/marceloavilaoliveira](https://github.com/marceloavilaoliveira)
- StackOverflow: [https://stackoverflow.com/users/4653675](https://stackoverflow.com/users/4653675)
