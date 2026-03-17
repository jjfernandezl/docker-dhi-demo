# Docker DHI Demo — Migrating to Hardened Images

This project demonstrates a side-by-side comparison of the official Docker Node image versus the DHI (Docker Hardened Images) equivalent. It shows what changes are needed to migrate a Node.js app to a hardened image and how to measure the security improvement using Docker Scout.

**What is DHI?** Docker Hardened Images from [dhi.io](https://dhi.io) are minimal, hardened base images with a reduced package footprint and fewer CVEs compared to official images.

---

## Prerequisites

- **Docker Desktop** (includes Docker Scout)
- **dhi.io account** (free tier required to pull DHI images)

```bash
docker login dhi.io
```

---

## Project Structure

```
.
├── Dockerfile          # Uses official node:20.19.5-alpine3.22
├── Dockerfile_dhi      # Uses dhi.io/node:20.19.5-alpine3.22
├── compose.yaml        # Runs full stack: Node.js app + PostgreSQL
├── index.js            # Guestbook API server
├── package.json
└── db/
    └── password.txt    # Database password (demo use only)
```

---

## Running the App

```bash
docker compose up --build
```

App available at: http://localhost:5001

---

## Build and Compare Images

Build both images, then use Docker Scout to compare them:

```bash
# Build official image
docker build -t guestbook:official .

# Build DHI image
docker build -f Dockerfile_dhi -t guestbook:dhi .

# Compare with Docker Scout
docker scout compare guestbook:dhi --to guestbook:official
```

### What to look for in Scout output

| Metric | What it shows |
|--------|---------------|
| **Package count** | DHI images ship with far fewer OS packages |
| **Image size** | Typically smaller with DHI due to reduced footprint |
| **CVE count** | Fewer vulnerabilities due to reduced attack surface |

---

## Key Difference Between the Two Dockerfiles

The only change needed to migrate from official to DHI:

| Stage | Official | DHI |
|-------|----------|-----|
| Build | `FROM node:20.19.5-alpine3.22` | `FROM dhi.io/node:20.19.5-alpine3.22-dev` |
| Production | `FROM node:20.19.5-alpine3.22` | `FROM dhi.io/node:20.19.5-alpine3.22` |

> **Note:** DHI uses a `-dev` variant for the build stage (includes npm and package manager tools) and a minimal variant for the final production image.

---

## App Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Web UI |
| GET | `/api/entries` | List all guestbook entries (JSON) |
| POST | `/api/entries` | Add entry — body: `{"name": "...", "message": "..."}` |
