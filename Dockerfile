# ---------- Build Stage ----------
FROM node:16.17.0-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --omit=dev


# Copy source code
COPY . .

# Build arguments
ARG TMDB_V3_API_KEY

# Environment variables for Vite build
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# Build the app
RUN npm run build


# ---------- Production Stage ----------
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

# Remove default nginx static files
RUN rm -rf ./*

# Copy built app from builder
COPY --from=builder /app/dist .

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
