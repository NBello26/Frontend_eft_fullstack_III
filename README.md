# 🌐 Frontend - Sistema de Gestión de Mascotas

Este repositorio contiene la aplicación **Frontend**, la interfaz de usuario principal dentro del Sistema de Gestión de Mascotas. Su rol principal es ofrecer una experiencia intuitiva, interactiva y responsiva para que los usuarios puedan registrar a sus mascotas, reportar pérdidas o hallazgos, visualizar mapas de geolocalización y gestionar sus perfiles y alertas de notificaciones.

La aplicación se comunica de forma centralizada con el ecosistema a través del **BFF (Backend-for-Frontend)** y el **ApiGateway**.

## 🚀 Arquitectura y Prácticas DevOps

Al ser la capa de presentación de cara al usuario, este servicio está optimizado para compilarse y servirse de forma eficiente. Su ciclo de vida y despliegue está totalmente automatizado mediante un pipeline de **CI/CD con GitHub Actions**:

1. **Validación:** Realiza el análisis estático de código (Linting) y verifica la integridad del proyecto.
2. **Compilación (Build):** Genera los artefactos estáticos de producción optimizados (HTML, CSS, JavaScript).
3. **Contenedorización:** Empaqueta los archivos estáticos dentro de una imagen de Docker utilizando un servidor web ligero y de alto rendimiento (como **Nginx**).
4. **Registro:** Sube la imagen a **Amazon Elastic Container Registry (ECR)**.
5. **Despliegue automatizado:** Ejecuta un despliegue remoto y seguro en la instancia **EC2** correspondiente (**Nodo Web**) mediante **AWS Systems Manager (SSM)**.
6. **Inyección de Configuración:** Inyecta variables de entorno esenciales (como las URLs base de la API, entornos de producción y llaves públicas de servicios externos) directamente en la configuración del servidor web durante el tiempo de ejecución o compilación.

### 🌐 Ecosistema de Infraestructura en AWS
Este componente opera en el nodo orientado al cliente externo, optimizando la latencia y la entrega de recursos al compartir entorno de red con la puerta de enlace pública:

* **Nodo Web:** ApiGateway y **Frontend** (Este repositorio) 🌐
* **Nodo Back 1:** Eureka Server y BFF
* **Nodo Back 2:** Microservicios de Mascotas y Usuarios
* **Nodo Back 3:** Microservicio de Geolocalización y Microservicio de Notificaciones
* **Nodo Back 4:** Motor de Coincidencias
* **Base de Datos:** SanosDB (PostgreSQL)

## 🛠️ Tecnologías Principales

* **Framework / Librería:** SPA moderna (React.js / Angular / Vue.js con TypeScript)*
* **Servidor Web Productivo:** Nginx (dentro del contenedor Docker)
* **Herramientas de Construcción:** Vite / Webpack / npm
* **Contenedores:** Docker
* **CI/CD:** GitHub Actions
* **Infraestructura AWS:** EC2, ECR, SSM, IAM

_*Nota: Adapta el framework exacto de la primera viñeta (Ej. React.js) según la tecnología específica que hayas implementado._

## ⚙️ Integración y Redes

* **Consumo de APIs:** El Frontend no realiza peticiones directas a los microservicios internos. Todas las interacciones con el ecosistema se canalizan a través de las puertas de enlace (`BFF` / `ApiGateway`), garantizando el desacoplamiento y manteniendo segura la topología interna de la VPC de AWS.
* **Acceso Público:** A diferencia de los microservicios de negocio encapsulados en subredes privadas, el Frontend se aloja en el **Nodo Web**, permitiendo el tráfico público bajo protocolos seguros (HTTP/HTTPS) para ser accesible desde cualquier navegador web.

## 📦 Repositorios del Proyecto

Explora el resto de la infraestructura y microservicios de este ecosistema:

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
*Desarrollado como parte del proyecto final de integración de arquitectura DevOps.*