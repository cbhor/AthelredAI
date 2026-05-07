FROM node:22-slim

# Install system dependencies for native modules (better-sqlite3)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install all dependencies (needed for build)
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build the frontend assets
RUN npm run build

# Create data directory for SQLite persistence
RUN mkdir -p data

# Set permissions (optional but good practice)
RUN chmod 777 data

ENV NODE_ENV=production
EXPOSE 3000

# Use tsx to run the server in production
# Node 22 supports type stripping, but tsx handles the module resolution more gracefully for this setup.
CMD ["npm", "start"]
