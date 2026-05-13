# --- ETAPA 1: Compilación ---
FROM node:22-alpine AS build-stage
WORKDIR /app

# Variable necesaria para que Vite use rutas relativas en lugar de localhost
ARG VITE_API_URL=/api/v1
ENV VITE_API_URL=$VITE_API_URL

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# --- ETAPA 2: Producción con Nginx (Reverse Proxy) ---
FROM nginx:stable-alpine AS production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html

# Variable de entorno para la IP PRIVADA del BFF (se inyecta en el docker run)
ENV BFF_PRIVATE_IP=127.0.0.1

# Generamos la configuración de Nginx dinámicamente al arrancar
# Esto redirige las peticiones de /api/v1 al BFF privado puerto 8087
CMD ["/bin/sh", "-c", "echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
    location /api/ { \
        proxy_pass http://'\"$BFF_PRIVATE_IP\"':8087/api/; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \
    } \
}' > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]

EXPOSE 80