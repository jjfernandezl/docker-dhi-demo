# Docker DHI Demo

This project shows how to migrate a Node.js app from the official Docker Node image to [Docker Hardened Images (DHI)](https://dhi.io) — minimal, security-focused images with a reduced attack surface and fewer CVEs.

Two Dockerfiles are provided for comparison:
- `Dockerfile` — uses the official `node:20.19.5-alpine3.22` image
- `Dockerfile_dhi` — uses the hardened `dhi.io/node:20.19.5-alpine3.22` equivalent

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Log in to dhi.io using your Docker account:

```bash
docker login dhi.io
```

---

## Run the app

```bash
docker compose up --build
```

App available at: http://localhost:5001

---

## Compare the images with Docker Scout

Build both images and use Docker Scout to compare them:

```bash
docker build -t guestbook:official .
docker build -f Dockerfile_dhi -t guestbook:dhi .

docker scout compare guestbook:dhi --to guestbook:official
```

Scout will show the difference in:
- **CVE count** — fewer vulnerabilities in the hardened image
- **Attack surface** — fewer packages means less exposure

---

## What changed between the two Dockerfiles

Only the base images are different:

| Stage | Official | DHI |
|-------|----------|-----|
| Build | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22-dev` |
| Production | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22` |

The `-dev` variant is used in the build stage because it includes npm. The production stage uses the minimal hardened image.
