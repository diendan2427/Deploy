# Dockerfile for BugHunter Backend (Railway)
# Build from root context, files are in server/ directory

# Use Node.js 18 LTS
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files from server directory
COPY server/package*.json ./

# Install dependencies (production only)
RUN npm ci --only=production

# Copy TypeScript source and config from server directory
COPY server/tsconfig.json ./
COPY server/src ./src

# Install dev dependencies for build
RUN npm install --save-dev typescript @types/node

# Build TypeScript to JavaScript
RUN npm run build

# Remove dev dependencies after build
RUN npm prune --production

# Expose port (Railway will use PORT env variable)
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000/api/debug/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the server
CMD ["node", "dist/app.js"]
