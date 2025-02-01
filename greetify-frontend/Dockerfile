FROM node:lts-alpine AS build-stage
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build-time arguments
ARG VITE_IS_STATIC=false
ARG VITE_APP_API_URL
ARG VITE_APP_VERSION
ARG VITE_APPLICATIONINSIGHTS_CONNECTION_STRING

# Make build arguments available as environment variables during build
ENV VITE_IS_STATIC=${VITE_IS_STATIC}
ENV VITE_APP_API_URL=${VITE_APP_API_URL}

# Build the application
RUN npm run build

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copy built assets
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy nginx configuration template and entrypoint script
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Entrypoint script runs when the container starts, we replace the PROXY_CONFIG placeholder with the valid location block for the API
COPY docker-entrypoint.sh /docker-entrypoint.sh 
RUN chmod +x /docker-entrypoint.sh

# Runtime environment variables with defaults
ENV VITE_IS_STATIC=$VITE_IS_STATIC
ENV VITE_APP_API_URL=$VITE_APP_API_URL
ENV VITE_APP_VERSION=$VITE_APP_VERSION

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]