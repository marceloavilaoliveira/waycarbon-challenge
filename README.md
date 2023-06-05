# WayCarbon Challenge - DevOps #

This repository contains a solution for a DevOps challenge proposed by the [WayCarbon](https://waycarbon.com/) company.

## The Challenge ##

The full description of the challenge can be find [here](doc/waycarbon-challenge.pdf).

In summary, the challenge is to provision a cloud environment for a web application that consists of a frontend component and a backend component, using one or more Docker containers. The components should be served on the same domain but with different paths. The frontend and backend need to form a cohesive application, with one depending on the other.

## The Project ##

This project is based on [knaopel/docker-frontend-backend-db](https://github.com/knaopel/docker-frontend-backend-db) repository, and consists of 4 services deployed in Docker containers. There is a web app (frontend) that communicates with an API (backend), which in turn reads/writes data to a database (mongo). These services are accessed through a web server (nginx).

The project structure can be better visualized [here](doc/project-structure.jpg).

The final result of the project can be seen running at http://waycarbon-challenge.duckdns.org/.

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
|-- doc/               => The documentation
|-- terraform/         => Terraform infrastructure definition
|-- docker-compose.yml => The Docker compose file
|-- .dockerignore      => Docker ignored files/directories
|-- .gitignore         => Git ignored files/directories
`-- README.md          => This file
```

## Infrastructure Provisioning ##

To provision the infrastructure, install the [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), and execute the following:

```bash
$ cd terraform
$ terraform init
$ terraform apply
```

## Author ##

**Marcelo Ávila de Oliveira**
[marceloavilaoliveira@gmail.com](marceloavilaoliveira@gmail.com)
