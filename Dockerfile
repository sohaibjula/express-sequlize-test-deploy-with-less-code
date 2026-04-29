# =========================
# 1. BUILD STAGE
# =========================
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install all dependencies (including dev)
RUN npm install

# Copy full source code
COPY . .

# Build TypeScript
RUN npm run build

# Install obfuscator globally
RUN npm install -g javascript-obfuscator

# Obfuscate compiled JS output
RUN javascript-obfuscator dist --output dist-obf \
    --compact true \
    --control-flow-flattening true \
    --string-array true

# =========================
# 2. PRODUCTION STAGE
# =========================
FROM node:20-alpine

WORKDIR /app

# Install ONLY production dependencies
COPY package*.json ./
RUN npm install --production

# Copy ONLY obfuscated build
COPY --from=builder /app/dist-obf ./dist

# Environment (optional - better inject from server)
# COPY .env ./

# Expose port
EXPOSE 3000

# Start app (IMPORTANT: match your server.ts output)
CMD ["node", "dist/server.js"]