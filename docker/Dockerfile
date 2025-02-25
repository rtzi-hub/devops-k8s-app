# Stage 1: Build the application
FROM node:18-alpine AS builder

WORKDIR /app

RUN apk add --no-cache ca-certificates bash vim procps curl

COPY package.json package-lock.json ./
RUN npm install --only=production

RUN chown -R 1500:1500 /app

# Stage 2: Final image
FROM node:18-alpine

RUN apk add --no-cache ca-certificates bash vim procps curl

RUN addgroup -g 1500 appuser && \
    adduser -u 1500 -G appuser -h /home/user -D appuser

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./ 
COPY docker-test.js ./ 
COPY k8s-test.js ./ 
COPY devops-assignment-index.html ./ 
COPY start.sh ./ 

RUN chown -R appuser:appuser /app && chmod -R 755 /app
RUN chmod +x ./start.sh

USER appuser
EXPOSE 8080

ENTRYPOINT ["/app/start.sh"]
CMD ["node", "docker-test.js"]
