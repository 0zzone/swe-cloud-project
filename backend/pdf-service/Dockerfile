# Use the official Node.js image as the base image
FROM node:24-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and pnpm-lock.yaml to the working directory
COPY package.json pnpm-lock.yaml ./

# Install dependencies using pnpm
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Copy the rest of the application code to the working directory
COPY . .

# Generate Prisma Client
RUN pnpm prisma generate

# Build the TypeScript code
RUN pnpm run build

# Expose the port the app runs on
EXPOSE 3002

# Command to run migrations and start the application
CMD ["sh", "-c", "pnpm prisma migrate deploy && pnpm start"]