# Stage 1: Build
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files and install all deps (dev + prod)
COPY package*.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source and build with vite
COPY . .
RUN yarn build

# Stage 2: Runtime
FROM node:18-alpine AS runtime

WORKDIR /app

# Copy built dist from build stage
COPY --from=build /app/dist ./dist

# Install a simple HTTP server
RUN npm install -g serve

EXPOSE 3000

# Start the HTTP server
CMD ["serve", "-s", "dist", "-l", "3000"]