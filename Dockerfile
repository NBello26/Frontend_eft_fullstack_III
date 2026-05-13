# --- ETAPA 1: Compilación ---
# Cambiamos a Node 22 para cumplir con los requisitos de Vite
FROM node:22-alpine AS build-stage
WORKDIR /app

# Instalamos dependencias (aprovechando el cache de capas)
COPY package*.json ./
RUN npm install

# Copiamos el resto del código y construimos el proyecto
COPY . .
RUN npm run build

# --- ETAPA 2: Producción con Nginx ---
FROM nginx:stable-alpine AS production-stage

# Vite genera los archivos en la carpeta 'dist'
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Configuramos Nginx para manejar el routing de Vue (Single Page Application)
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]