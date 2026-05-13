# 🖥️ Frontend - Sistema de Gestión de Mascotas

Este repositorio contiene la aplicación **Frontend** (construida en Vue.js) para el Sistema de Gestión de Mascotas. Actúa como la interfaz de usuario principal, comunicándose de forma segura con los microservicios del backend a través de un **BFF (Backend For Frontend)** utilizando Nginx como Reverse Proxy.

## 🚀 Arquitectura y Despliegue

Este proyecto está completamente dockerizado y cuenta con un pipeline de **Integración y Despliegue Continuo (CI/CD)** implementado con GitHub Actions. 

El flujo de despliegue automatizado realiza las siguientes acciones:
1. Compila el proyecto de Vue.js (Node 22).
2. Construye una imagen Docker basada en **Nginx**.
3. Sube la imagen a **Amazon Elastic Container Registry (ECR)**.
4. Despliega la nueva imagen en una instancia **Amazon EC2** a través de AWS Systems Manager (SSM).

### 🌐 Ecosistema de Infraestructura en AWS
Este microservicio es parte de una arquitectura distribuida alojada en AWS, distribuida en los siguientes nodos (EC2):

* **Nodo Web:** ApiGateway y **Frontend** (Este repositorio) 📍
* **Nodo Back 1:** Eureka Server y BFF (Backend For Frontend)
* **Nodo Back 2:** Microservicios de Mascotas y Usuarios
* **Nodo Back 3:** Microservicios de Geolocalización y Notificaciones
* **Nodo Back 4:** Motor de Coincidencias
* **Base de Datos:** SanosDB (PostgreSQL)

## 🛠️ Tecnologías Principales

* **Framework:** Vue.js 3 / Vite
* **Servidor Web / Proxy:** Nginx (Alpine)
* **Contenedores:** Docker
* **CI/CD:** GitHub Actions
* **Cloud (AWS):** EC2, ECR, SSM, IAM

## ⚙️ Configuración de Nginx (Reverse Proxy)

Para garantizar la seguridad y no exponer las IPs privadas del backend al navegador del cliente, este frontend utiliza un enfoque de **Reverse Proxy**. 

Todas las peticiones que el cliente realiza a `/api/*` son interceptadas por el servidor Nginx (en el contenedor Docker) y redirigidas internamente a la IP privada de la instancia EC2 que aloja el **BFF**. Esto mantiene nuestra red interna de microservicios y Eureka 100% aislada del internet público.

## 📦 Repositorios del Proyecto

Este ecosistema está compuesto por múltiples microservicios. Puedes explorar el código fuente de cada uno de ellos en los siguientes enlaces:

**Frontend y Puertas de Enlace**
* 🌐 [Frontend_eft_fullstack_III](https://github.com/NBello26/Frontend_eft_fullstack_III) *(Estás aquí)*
* 🚪 [ApiGateway_eft_fullstack_III](https://github.com/NBello26/ApiGateway_eft_fullstack_III)
* 🌉 [BFF_eft_fullstack_III](https://github.com/NBello26/BFF_eft_fullstack_III)

**Descubrimiento y Base de Datos**
* 🧭 [Eureka_eft_fullstack_III](https://github.com/NBello26/Eureka_eft_fullstack_III)
* 🗄️ [BD_eft_fullstack_III](https://github.com/NBello26/BD_eft_fullstack_III)

**Microservicios de Negocio**
* 🐾 [Reporte_Mascota_eft_fullstack_III](https://github.com/NBello26/Reporte_Mascota_eft_fullstack_III)
* 👤 [Usuarios_eft_fullstack_III](https://github.com/NBello26/Usuarios_eft_fullstack_III)
* 📍 [Geolocalizacion_eft_fullstack_III](https://github.com/NBello26/Geolocalizacion_eft_fullstack_III)
* 🔔 [Notificaciones_eft_fullstack_III](https://github.com/NBello26/Notificaciones_eft_fullstack_III)
* 🧩 [Coincidencias_eft_fullstack_III](https://github.com/NBello26/Coincidencias_eft_fullstack_III)

---

**Video demostración de servicios funcionando**
* https://drive.google.com/drive/folders/1REBfW7_wzcVq62muZwWfpFEhCXPZ8N6z?usp=sharing

---
*Desarrollado como parte del proyecto de integración Devops.*
