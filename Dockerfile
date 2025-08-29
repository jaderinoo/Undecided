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
FROM nginx:alpine AS runtime

WORKDIR /usr/share/nginx/html

# Copy built dist from build stage
COPY --from=build /app/dist .

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]