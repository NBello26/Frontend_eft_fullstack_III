# --- ETAPA 1: Compilación ---
FROM node:18-alpine AS build-stage
WORKDIR /app

# Instalamos dependencias
COPY package*.json ./
RUN npm install

# Copiamos el resto del código y construimos el proyecto
COPY . .
RUN npm run build

# --- ETAPA 2: Producción con Nginx ---
FROM nginx:stable-alpine AS production-stage

# Copiamos los archivos compilados desde la etapa anterior
# IMPORTANTE: Vue suele generar la carpeta 'dist'. Si la tuya es 'build', cambia dist por build.
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Configuramos Nginx para que soporte el enrutamiento de Vue (SPA)
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