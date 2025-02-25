# Stage 1: Build dependencies
FROM node:18-alpine AS builder

WORKDIR /app

# Install required packages
RUN apk add --no-cache ca-certificates bash vim procps curl

# Copy package files
COPY app/package.json ./  

# Install dependencies
RUN npm install

# Stage 2: Final image
FROM node:18-alpine

# Install required packages
RUN apk add --no-cache ca-certificates bash vim procps curl

# Create user and group with ID 1500
RUN addgroup -g 1500 appuser && \
    adduser -u 1500 -G appuser -h /home/user -D appuser

# Set working directory
WORKDIR /app

# Copy dependencies from builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Copy application files
COPY app/docker-test.js ./
COPY app/k8s-test.js ./
COPY app/devops-assignment-index.html ./
COPY app/start.sh ./

# Fix permissions (NOW SAFE)
RUN chown -R appuser:appuser /app && chmod -R 755 /app

# Make start script executable
RUN chmod +x /app/start.sh

# Switch to non-root user
USER appuser

# Set the home directory
ENV HOME=/home/user

# Expose the application port
EXPOSE 8080

# Use start.sh as entrypoint
ENTRYPOINT ["/app/start.sh"]

# Default command
CMD ["node", "docker-test.js"]
