# --- ETAPA 1: Compilación (Ejemplo Node.js) ---
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Cambia 'build' por 'dist' si usas Vite o Angular
RUN npm run build 

# --- ETAPA 2: Ejecución (Nginx) ---
FROM nginx:alpine
# Copiamos los archivos compilados a la carpeta de Nginx
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]