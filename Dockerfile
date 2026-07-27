# Stage 1: Build stage
FROM demonstrationorg/dhi-node:22.23.1-alpine3.24-dev AS build

WORKDIR /usr/src/app

# Copy package files first to leverage Docker cache
COPY package-lock.json package.json ./

# Install production dependencies only
RUN npm install --omit=dev && \
npm cache clean --force

# Copy the rest of the application files
COPY ./index.js .

# Stage 2: Production stage
FROM demonstrationorg/dhi-node:22.23.1-alpine3.24 AS production

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/index.js ./index.js

EXPOSE 5000

CMD ["node", "index.js"]