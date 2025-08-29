# Use Node.js Alpine as base image for better compatibility
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json yarn.lock ./

# Install dependencies using yarn
RUN yarn install --frozen-lockfile --production

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Install serve globally
RUN yarn global add serve

# Expose port
EXPOSE 3000

# Start the application
CMD ["yarn", "run", "serve"] 