# Inventario App

Aplicación web para gestionar el inventario de un puesto ambulante de frutas y verduras. Construida con React + TypeScript, usa FIWARE Orion como backend de datos y Keycloak para la autenticación de usuarios.

---

## Índice

1. [Arquitectura](#arquitectura)
2. [Tecnologías](#tecnologías)
3. [Estructura del proyecto](#estructura-del-proyecto)
4. [Variables de entorno](#variables-de-entorno)
5. [Desarrollo local](#desarrollo-local)
6. [Despliegue en producción](#despliegue-en-producción)
7. [Autenticación con Keycloak](#autenticación-con-keycloak)
8. [FIWARE Orion — API de inventario](#fiware-orion--api-de-inventario)
9. [Componentes](#componentes)
10. [Estilos](#estilos)
11. [Tipos TypeScript](#tipos-typescript)

---

## Arquitectura

### Desarrollo local

```
┌─────────────────────────────────┐
│   Navegador (React + Vite)      │
│   http://localhost:5173         │
└────────────┬────────────────────┘
             │ /v2/* (proxy Vite)
┌────────────▼────────────────────┐
│   Orion Context Broker (FIWARE) │
│   http://localhost:1026         │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   MongoDB · puerto 27017        │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│   Keycloak · http://localhost:8080│
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   PostgreSQL · puerto 5432      │
└─────────────────────────────────┘
```

### Producción (AWS EC2)

```
Internet
    │
    ▼ 443 (HTTPS)
┌─────────────────────────────────┐
│   Nginx (reverse proxy)         │
│   /auth/*  → Keycloak :8080     │
│   /v2/*    → Orion :1026        │
│   /*       → Frontend (static)  │
└────┬──────────────┬─────────────┘
     │              │
     ▼              ▼
┌─────────┐   ┌──────────────────┐
│  Orion  │   │    Keycloak      │
│  :1026  │   │    :8080         │
└────┬────┘   └────────┬─────────┘
     │                 │
┌────▼────┐   ┌────────▼─────────┐
│ MongoDB │   │   PostgreSQL     │
└─────────┘   └──────────────────┘
```

Nginx es el único punto de entrada. Keycloak no está expuesto directamente — se accede bajo la ruta `/auth/`. El panel de administración de Keycloak solo es accesible mediante túnel SSH.

Cada usuario tiene su propio espacio de datos en Orion gracias al header `Fiware-Service`, construido a partir del ID de usuario de Keycloak, garantizando el aislamiento total entre inventarios.

---

## Tecnologías

| Capa | Tecnología | Versión |
|---|---|---|
| Frontend | React + TypeScript | 19 / 6 |
| Build | Vite | 8 |
| Estilos | Tailwind CSS | 4 |
| Autenticación | Keycloak | 24 |
| Context Broker | FIWARE Orion | 3.10.1 |
| Base de datos (Orion) | MongoDB | 6 |
| Base de datos (Keycloak) | PostgreSQL | 16 |
| Orquestación | Docker Compose | — |
| Proxy inverso (prod) | Nginx | — |

---

## Estructura del proyecto

```
Inventario-App/
├── docker-compose.yml          # Stack completo de infraestructura
├── nginx/
│   └── default.conf            # Config de Nginx para producción
├── keycloak/
│   └── realm-inventario.json   # Configuración automática del realm
├── src/
│   ├── main.tsx                # Entrada — inicializa Keycloak antes de renderizar
│   ├── App.tsx                 # Componente raíz
│   ├── index.css               # CSS global (importa todos los demás)
│   ├── App.css                 # Estilos del layout principal
│   ├── types/
│   │   └── index.ts            # Interfaces TypeScript (Product, NgsiEntity)
│   ├── services/
│   │   ├── keycloak.ts         # Instancia y configuración de Keycloak
│   │   └── orion.ts            # Cliente NGSI v2 para Orion
│   └── components/
│       ├── Modal.tsx / .css         # Modal reutilizable
│       ├── ProductTable.tsx / .css  # Tabla de productos
│       └── ProductForm.tsx / .css   # Formulario de crear/editar
└── vite.config.ts              # Proxy /v2 → Orion (solo desarrollo)
```

---

## Variables de entorno

El archivo `.env` no se incluye en el repositorio. Crea uno en la raíz del proyecto.

### Local (`.env`)

```env
MONGO_PORT=27017
ORION_PORT=1026
POSTGRES_DB=keycloak
POSTGRES_USER=keycloak
POSTGRES_PASSWORD=keycloak
POSTGRES_PORT=5432
KEYCLOAK_ADMIN=<usuario-seguro>
KEYCLOAK_ADMIN_PASSWORD=<contraseña-segura>
KEYCLOAK_PORT=8080
VITE_KEYCLOAK_URL=http://localhost:8080
VITE_KEYCLOAK_REALM=inventario
VITE_KEYCLOAK_CLIENT_ID=inventario-app
VITE_ORION_URL=http://localhost:1026
```

### Producción (`.env` en el servidor)

```env
MONGO_PORT=27017
ORION_PORT=1026
POSTGRES_DB=keycloak
POSTGRES_USER=keycloak
POSTGRES_PASSWORD=keycloak
POSTGRES_PORT=5432
KEYCLOAK_ADMIN=<usuario-seguro>
KEYCLOAK_ADMIN_PASSWORD=<contraseña-segura>
KEYCLOAK_PORT=8080
KC_PROXY_HEADERS=xforwarded
KC_HOSTNAME=<ip-o-dominio>
KC_HOSTNAME_PORT=443
KC_HTTP_RELATIVE_PATH=/auth
VITE_KEYCLOAK_URL=https://<ip-o-dominio>/auth
VITE_KEYCLOAK_REALM=inventario
VITE_KEYCLOAK_CLIENT_ID=inventario-app
VITE_ORION_URL=https://<ip-o-dominio>:1026
```

Las variables `KC_PROXY_HEADERS`, `KC_HOSTNAME`, `KC_HOSTNAME_PORT` y `KC_HTTP_RELATIVE_PATH` solo se pasan a Keycloak si están definidas en el `.env` (sintaxis pass-through en docker-compose). En local no deben existir.

---

## Desarrollo local

### Requisitos previos

- Docker y Docker Compose
- Node.js 18+

### 1. Levantar la infraestructura

```bash
docker compose up -d
```

Levanta: MongoDB, Orion, PostgreSQL y Keycloak con el realm `inventario` preconfigurado.

Keycloak tarda ~1 minuto. Para verificar que está listo:

```bash
docker logs inventario-keycloak 2>&1 | grep "started in"
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Arrancar el servidor de desarrollo

```bash
npm run dev
```

La app estará en `http://localhost:5173`.

### Credenciales por defecto

| Servicio | URL | Usuario | Contraseña |
|---|---|---|---|
| App | http://localhost:5173 | usuario | usuario123 |
| Keycloak Admin | http://localhost:8080/admin | admin | *(definido en .env)* |

### Parar los contenedores

```bash
docker compose down          # Para los contenedores
docker compose down -v       # Para y elimina los volúmenes (borra datos)
```

---

## Despliegue en producción

### Requisitos

- Instancia EC2 (Ubuntu) con Docker, Docker Compose y Node.js
- Nginx instalado
- Certificado SSL (autofirmado o Let's Encrypt)
- Puertos abiertos en el Security Group: **22**, **80**, **443**

### 1. Clonar el repositorio y configurar el entorno

```bash
git clone https://github.com/<usuario>/Inventario-App.git
cd Inventario-App
```

Crea el `.env` con los valores de producción (ver sección [Variables de entorno](#variables-de-entorno)).

### 2. Configurar Nginx

```bash
sudo cp nginx/default.conf /etc/nginx/sites-available/default
sudo nginx -t && sudo systemctl reload nginx
```

### 3. Construir el frontend

```bash
npm install
npm run build
sudo rm -rf /var/www/html/*
sudo cp -r dist/* /var/www/html/
```

### 4. Levantar los contenedores

```bash
sudo docker compose up -d
```

### 5. Actualizar el repositorio en producción

```bash
git pull
npm run build
sudo rm -rf /var/www/html/* && sudo cp -r dist/* /var/www/html/
sudo nginx -t && sudo systemctl reload nginx
sudo docker compose down && sudo docker compose up -d
```

### Acceder al panel de administración de Keycloak

El panel de administración no está expuesto públicamente. Accede mediante túnel SSH:

```bash
ssh -i /ruta/clave.pem -L 8080:localhost:8080 ubuntu@<ip-servidor>
```

Luego abre en el navegador: `http://localhost:8080/auth/admin`

---

## Autenticación con Keycloak

### Flujo de autenticación

Al abrir la app, Keycloak intercepta el acceso antes de que se renderice ningún componente:

```typescript
// src/main.tsx
keycloak.init({ onLoad: 'login-required', checkLoginIframe: false })
  .then(authenticated => {
    if (!authenticated) return
    createRoot(document.getElementById('root')!).render(<App />)
  })
```

Si el usuario no tiene sesión activa es redirigido al login de Keycloak. Solo tras autenticarse se monta la aplicación React.

### Configuración del cliente

```typescript
// src/services/keycloak.ts
import Keycloak from 'keycloak-js'

const keycloak = new Keycloak({
  url: import.meta.env.VITE_KEYCLOAK_URL,
  realm: import.meta.env.VITE_KEYCLOAK_REALM,
  clientId: import.meta.env.VITE_KEYCLOAK_CLIENT_ID,
})

export default keycloak
```

### Datos del usuario en la app

```typescript
const username = keycloak.tokenParsed?.preferred_username ?? ''
```

### Cerrar sesión

```tsx
<button onClick={() => keycloak.logout()}>Cerrar sesión</button>
```

### Realm preconfigurado

Al arrancar los contenedores, Keycloak importa automáticamente `keycloak/realm-inventario.json`, que incluye:

- **Realm:** `inventario`
- **Cliente:** `inventario-app` (público, redirect a `http://localhost:5173/*` y `https://<ip>/*`)
- **Usuario demo:** `usuario` / `usuario123`

---

## FIWARE Orion — API de inventario

### Protocolo NGSI v2

Orion almacena los productos como **entidades NGSI v2**:

```json
{
  "id": "urn:ngsi-ld:InventoryItem:1746350123456",
  "type": "InventoryItem",
  "name":     { "type": "Text",   "value": "Manzana roja" },
  "category": { "type": "Text",   "value": "Frutas" },
  "quantity": { "type": "Number", "value": 50 },
  "unit":     { "type": "Text",   "value": "kg" },
  "price":    { "type": "Number", "value": 1.20 }
}
```

### Aislamiento por usuario

```typescript
function headers(extra: Record<string, string> = {}): Record<string, string> {
  const userId = (keycloak.tokenParsed?.sub ?? 'anonymous').replace(/-/g, '')
  return {
    'Authorization': `Bearer ${keycloak.token}`,
    'Fiware-Service': `user${userId}`.slice(0, 50),
    'Fiware-ServicePath': '/',
    ...extra,
  }
}
```

### Operaciones disponibles

| Operación | Método | Ruta |
|---|---|---|
| Listar productos | `GET` | `/v2/entities?type=InventoryItem&limit=100` |
| Crear producto | `POST` | `/v2/entities` |
| Actualizar producto | `PATCH` | `/v2/entities/{id}/attrs` |
| Eliminar producto | `DELETE` | `/v2/entities/{id}` |

### Proxy

En **desarrollo**, Vite redirige `/v2/*` a Orion para evitar CORS:

```typescript
// vite.config.ts
server: {
  proxy: {
    '/v2': { target: 'http://localhost:1026', changeOrigin: true },
  },
},
```

En **producción**, Nginx hace el mismo proxy con la directiva `location /v2/`.

---

## Componentes

### `App`

Componente raíz. Gestiona el estado global y orquesta las llamadas a Orion.

| Estado | Tipo | Descripción |
|---|---|---|
| `products` | `Product[]` | Lista de productos cargados |
| `loading` | `boolean` | Indicador de carga inicial |
| `error` | `string \| null` | Mensaje de error de Orion |
| `showForm` | `boolean` | Controla el modal de nuevo producto |
| `editing` | `Product \| null` | Producto seleccionado para editar |

### `ProductTable`

Muestra los productos en una tabla con acciones de editar y eliminar.

```typescript
interface Props {
  products: Product[]
  onEdit: (product: Product) => void
  onDelete: (id: string) => void
}
```

### `ProductForm`

Formulario para crear o editar un producto. Si recibe `initial`, se comporta como formulario de edición.

```typescript
interface Props {
  initial?: Product
  onSubmit: (data: Omit<Product, 'id'>) => void
  onCancel: () => void
}
```

| Campo | Tipo | Valores posibles |
|---|---|---|
| Nombre | texto | libre |
| Categoría | select | Frutas, Verduras, Hortalizas |
| Unidad | select | kg, Manojo, Caja |
| Cantidad | número | ≥ 0 |
| Precio | número | ≥ 0 (paso 0.01) |

### `Modal`

Contenedor modal genérico y reutilizable.

```typescript
interface Props {
  title: string
  children: React.ReactNode
  onClose: () => void
}
```

---

## Estilos

Tailwind CSS v4 con directivas `@apply`. Cada componente tiene su propio `.css` importado desde `index.css`:

```css
@import "tailwindcss";
@import "./App.css";
@import "./components/Modal.css";
@import "./components/ProductForm.css";
@import "./components/ProductTable.css";
```

| Archivo | Clases principales |
|---|---|
| `App.css` | `.app`, `.app-header`, `.app-header-btn`, `.app-header-logout`, `.app-error` |
| `Modal.css` | `.modal-overlay`, `.modal-container`, `.modal-header`, `.modal-body` |
| `ProductForm.css` | `.form-grid`, `.form-label`, `.form-input`, `.btn-submit`, `.btn-cancel` |
| `ProductTable.css` | `.table-wrapper`, `.table`, `.table-row`, `.btn-edit`, `.btn-delete` |

---

## Tipos TypeScript

```typescript
// src/types/index.ts

export interface Product {
  id: string
  name: string
  category: string
  quantity: number
  unit: string
  price: number
}

export interface NgsiAttribute<T> {
  type: string
  value: T
}

export interface NgsiEntity {
  id: string
  type: string
  name: NgsiAttribute<string>
  category: NgsiAttribute<string>
  quantity: NgsiAttribute<number>
  unit: NgsiAttribute<string>
  price: NgsiAttribute<number>
}
```
