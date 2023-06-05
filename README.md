# WayCarbon Challenge - DevOps #

This repository contains a solution for a DevOps challenge proposed by the [WayCarbon](https://waycarbon.com/) company.

## The Challenge ##

The full description of the challenge can be find [here](doc/waycarbon-challenge.pdf).

In summary, the challenge is to provision a cloud environment for a web application that consists of a frontend component and a backend component, using one or more Docker containers. The components should be served on the same domain but with different paths. The frontend and backend need to form a cohesive application, with one depending on the other.

## The Project ##

This project is based on [knaopel/docker-frontend-backend-db](https://github.com/knaopel/docker-frontend-backend-db) repository, and consists of 4 services deployed in Docker containers. There is a web app (frontend) that communicates with an API (backend), which in turn reads/writes data to a database (mongo). These services are accessed through a web server (nginx).

The project structure is shown following: 

![Project Structure](doc/project-structure.png)

The final result of the project can be seen running at:

- Frontend: http://waycarbon-challenge.duckdns.org/
- Backend: http://waycarbon-challenge.duckdns.org/api

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
|-- terraform/         => Terraform infrastructure definition
|-- doc/               => Documentation
|-- docker-compose.yml => Docker compose file
|-- .env               => Environment definition file
|-- .dockerignore      => Docker ignored files/directories
|-- .gitignore         => Git ignored files/directories
`-- README.md          => This file
```

## Installing the automation tools ##

To use all the commands and scripts listed here, you need to have installed the following tools:

- [Docker](https://docs.docker.com/engine/install/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Building the Docker images ##

To build the Docker images for both the frontend and the backend execute the following:

```bash
$ bash/build.sh
```

If you need to build just a specific component, you can specify it using the -c flag:

```bash
$ bash/build.sh -c frontend|backend
```

## Pushing the Docker images to ECR ##

To push the Docker images for both the frontend and the backend execute the following:

```bash
$ bash/push.sh
```

If you need to push just a specific component, you can specify it using the -c flag:

```bash
$ bash/build.sh -c frontend|backend
```

## Provisioning the Infrastructure ##

To provision the infrastructure in AWS execute the following:

```bash
$ cd terraform
$ terraform init
$ terraform apply
```

## Author ##

**Marcelo Ávila de Oliveira**
[marceloavilaoliveira@gmail.com](marceloavilaoliveira@gmail.com)
