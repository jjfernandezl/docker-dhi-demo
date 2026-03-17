# Docker Hardened Images (DHI) Migration Demo

This project demonstrates migrating a Node.js application from the official Docker Node image to [Docker Hardened Images (DHI)](https://docs.docker.com/dhi/).

Two Dockerfiles are provided for side-by-side comparison:
- `Dockerfile` — uses the official image
- `Dockerfile_dhi` — uses the equivalent DHI hardened image

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Docker account (free tier - DHI is available at no cost)
- Authenticate with DHI registry:

```bash
docker login dhi.io
```

---

## Quick Start

Build and run the application with the official Node image:

```bash
docker compose up --build
```

The application will be available at `http://localhost:5001`.

To stop the services:

```bash
docker compose down
```

---

## Security Analysis with Docker Scout

Build both images and use [Docker Scout](https://docs.docker.com/scout/) to compare their security profiles:

```bash
docker build -t workshop:official .
docker build -f Dockerfile_dhi -t workshop:dhi .

docker scout compare workshop:dhi --to workshop:official
```

Docker Scout displays key differences:
- **CVE Count** — total number of known vulnerabilities
- **Attack Surface** — reduced package count lowers exposure
- **Image Size** — DHI images are typically smaller


---

## Dockerfile Changes

The migration requires only changing teh FROM statement of the Dockerfile. The structure and all other Dockerfile directives remain identical:

| Build Stage | Official | DHI |
|---|---|---|
| Build (Stage 1) | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22-dev` |
| Production (Stage 2) | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22` |


---


## Resources

- [Docker Hardened Images Documentation](https://docs.docker.com/dhi/)
- [Docker Scout Documentation](https://docs.docker.com/scout/)
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
