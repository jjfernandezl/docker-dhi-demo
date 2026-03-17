# Docker Hardened Images (DHI) Migration Demo

This project demonstrates migrating a Node.js application from the official Docker Node image to [Docker Hardened Images (DHI)](https://docs.docker.com/dhi/) — security-hardened, minimal images designed to reduce your attack surface and CVE exposure.

Two Dockerfiles are provided for side-by-side comparison:
- `Dockerfile` — uses the official `node:20.19.5-alpine3.22` image
- `Dockerfile_dhi` — uses the equivalent DHI hardened image `dhi.io/node:20.19.5-alpine3.22`

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
- **Remediation** — actionable guidance for fixes


---

## Dockerfile Changes

The migration requires only base image updates. The structure and all other Dockerfile directives remain identical:

| Build Stage | Official | DHI |
|---|---|---|
| Build (Stage 1) | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22-dev` |
| Production (Stage 2) | `node:20.19.5-alpine3.22` | `dhi.io/node:20.19.5-alpine3.22` |

### Understanding Image Variants

DHI provides two image variants for each base image:

**Development (`-dev`) variant:**
- Includes npm, yarn, and other package managers
- Contains build tools and development utilities
- Used in the **build stage** to install application dependencies
- Larger attack surface (acceptable for build-time only)

**Production variant (default):**
- Contains only the Node.js runtime
- All package managers and build tools removed
- Used in the **final stage** to run the application
- Minimal attack surface optimized for security

### Why Multi-Stage with Dev Variant?

The multi-stage Dockerfile pattern provides critical security benefits:

1. **Build Stage** — Uses the `-dev` variant because we need npm to install dependencies from `package.json`
2. **Copy Dependencies** — Only the installed `node_modules` are copied to the production stage
3. **Production Stage** — Uses the minimal production variant (no build tools, no npm)
4. **Result** — Final image contains zero build-time tools or package managers

This approach ensures your deployed container cannot install additional packages or modify dependencies at runtime, significantly reducing your attack surface compared to using a single-stage build.

## Key Benefits of DHI

- **Security hardened** — Stripped of development packages and debug tools
- **Reduced CVE count** — Smaller attack surface means fewer vulnerabilities
- **Smaller images** — Faster pulls and less storage overhead
- **Drop-in replacement** — Compatible API with official Docker images

## Resources

- [Docker Hardened Images Documentation](https://docs.docker.com/dhi/)
- [Docker Scout Documentation](https://docs.docker.com/scout/)
- [Docker Build Best Practices](https://docs.docker.com/build/building/best-practices/)
