# WayCarbon Challenge - DevOps #

This repository contains a solution for a DevOps challenge proposed by the [WayCarbon](https://waycarbon.com/) company.

## The Challenge ##

The full description of the challenge can be find [here](doc/waycarbon-challenge.pdf).

In summary, the challenge is to provision a cloud environment for a web application that consists of a frontend component and a backend component, using one or more Docker containers. The components should be served on the same domain but with different paths. The frontend and backend need to form a cohesive application, with one depending on the other.

## Repository structure ##

```
.
|-- backend/           => Backend component of the web app
|-- frontend/          => Frontend component of the web app
|-- nginx/             => Nginx configuration
|-- data/              => Mongo DB data (ignored by Git)
|-- doc/               => The documentation
|-- docker-compose.yml => The Docker compose file
|-- .dockerignore      => Docker ignored files/directories
|-- .gitignore         => Git ignored files/directories
`-- README.md          => This file
```

## Contact ##

**Marcelo Ávila de Oliveira**
[marceloavilaoliveira@gmail.com](marceloavilaoliveira@gmail.com)
