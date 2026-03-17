# Docker Hardened Images (DHI) Migration Demo

This project demonstrates migrating a Node.js application from the official Docker Node image to [Docker Hardened Images (DHI)](https://docs.docker.com/dhi/) — security-hardened, minimal images designed to reduce your attack surface and CVE exposure.

Two Dockerfiles are provided for side-by-side comparison:
- `Dockerfile` — uses the official `node:20.19.5-alpine3.22` image
- `Dockerfile_dhi` — uses the equivalent DHI hardened image `dhi.io/node:20.19.5-alpine3.22`

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) with Docker Engine 25.0+
- Docker account (free tier supported)
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
docker build -t guestbook:official .
docker build -f Dockerfile_dhi -t guestbook:dhi .

docker scout compare guestbook:dhi --to guestbook:official
```

Docker Scout displays key differences:
- **CVE Count** — total number of known vulnerabilities
- **Attack Surface** — reduced package count lowers exposure
- **Image Size** — DHI images are typically smaller
- **Remediation** — actionable guidance for fixes

For a detailed vulnerability report on a single image:

```bash
docker scout cves guestbook:dhi
```

---

## Dockerfile Changes

The migration requires only base image updates. The structure and all other Dockerfile directives remain identical:

| Build Stage | Official | DHI |
|---|---|---|
| Build (Stage 1) | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22-dev` |
| Production (Stage 2) | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22` |

### Image Variants

- **`-dev` variant**: Includes npm and build tools, used for dependency installation
- **Production variant**: Minimal footprint for runtime, optimized for security

This multi-stage approach ensures your production image contains only runtime dependencies, minimizing attack surface.

## Key Benefits of DHI

- **Security hardened** — Stripped of development packages and debug tools
- **Reduced CVE count** — Smaller attack surface means fewer vulnerabilities
- **Smaller images** — Faster pulls and less storage overhead
- **Drop-in replacement** — Compatible API with official Docker images

## Resources

- [Docker Hardened Images Documentation](https://docs.docker.com/dhi/)
- [Docker Scout Documentation](https://docs.docker.com/scout/)
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
