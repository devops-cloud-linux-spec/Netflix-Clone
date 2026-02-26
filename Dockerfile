# ---------- Build Stage ----------
FROM node:16.17.0-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (no lock file required)
RUN npm install

# Copy source
COPY . .

# Build arguments
ARG TMDB_V3_API_KEY

# Vite environment variables
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# Build app
RUN npm run build


# ---------- Production Stage ----------
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/dist .

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
