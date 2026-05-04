# Inventario App

Aplicación web para gestionar el inventario de un puesto ambulante de frutas y verduras. Construida con React + TypeScript, usa FIWARE Orion como backend de datos y Keycloak para la autenticación de usuarios.

---

## Índice

1. [Arquitectura](#arquitectura)
2. [Tecnologías](#tecnologías)
3. [Estructura del proyecto](#estructura-del-proyecto)
4. [Puesta en marcha](#puesta-en-marcha)
5. [Autenticación con Keycloak](#autenticación-con-keycloak)
6. [FIWARE Orion — API de inventario](#fiware-orion--api-de-inventario)
7. [Componentes](#componentes)
8. [Estilos](#estilos)
9. [Tipos TypeScript](#tipos-typescript)

---

## Arquitectura

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
│   MongoDB                       │
│   puerto 27017                  │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│   Keycloak (Autenticación)      │
│   http://localhost:8080         │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   PostgreSQL                    │
│   puerto 5432                   │
└─────────────────────────────────┘
```

Cada usuario tiene su propio espacio de datos en Orion gracias al header `Fiware-Service`, construido a partir del ID de usuario de Keycloak. Esto garantiza el aislamiento total entre inventarios de distintos usuarios.

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

---

## Estructura del proyecto

```
Inventario-App/
├── docker-compose.yml          # Stack completo de infraestructura
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
└── vite.config.ts              # Proxy /v2 → Orion
```

---

## Puesta en marcha

### Requisitos previos

- Docker y Docker Compose instalados
- Node.js 18+

### 1. Levantar la infraestructura

```bash
docker compose up -d
```

Esto levanta automáticamente:
- MongoDB (puerto 27017)
- Orion Context Broker (puerto 1026)
- PostgreSQL (puerto 5432)
- Keycloak con el realm `inventario` preconfigurado (puerto 8080)

Keycloak tarda ~1 minuto en estar listo. Puedes verificarlo con:

```bash
docker logs inventario-keycloak 2>&1 | grep "Running the server"
```

### 2. Instalar dependencias del frontend

```bash
npm install
```

### 3. Arrancar el servidor de desarrollo

```bash
npm run dev
```

La app estará disponible en `http://localhost:5173`. Al acceder, redirigirá automáticamente al login de Keycloak.

### Credenciales por defecto

| Servicio | URL | Usuario | Contraseña |
|---|---|---|---|
| App | http://localhost:5173 | usuario | usuario123 |
| Keycloak Admin | http://localhost:8080/admin | admin | admin |

### Parar los contenedores

```bash
docker compose down
```

Para eliminar también los datos almacenados:

```bash
docker compose down -v
```

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
  url: 'http://localhost:8080',
  realm: 'inventario',
  clientId: 'inventario-app',
})

export default keycloak
```

### Datos del usuario en la app

El nombre del usuario autenticado se obtiene del token JWT:

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
- **Cliente:** `inventario-app` (público, redirect a `http://localhost:5173/*`)
- **Usuario demo:** `usuario` / `usuario123`

Para añadir más usuarios, accede al panel de administración en `http://localhost:8080/admin`.

---

## FIWARE Orion — API de inventario

### Protocolo NGSI v2

Orion almacena los productos como **entidades NGSI v2**. Cada producto es una entidad con atributos tipados:

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

Cada usuario tiene sus datos aislados mediante el header `Fiware-Service`. El valor se construye a partir del UUID de Keycloak eliminando los guiones (Orion solo acepta caracteres alfanuméricos y guiones bajos):

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

Dos usuarios distintos nunca verán los productos del otro, aunque compartan la misma instancia de Orion.

### Operaciones disponibles

#### Obtener todos los productos
```typescript
GET /v2/entities?type=InventoryItem&limit=100
```

#### Crear un producto
```typescript
POST /v2/entities
Content-Type: application/json

{
  "id": "urn:ngsi-ld:InventoryItem:1746350123456",
  "type": "InventoryItem",
  "name": { "type": "Text", "value": "Manzana roja" },
  ...
}
```

#### Actualizar un producto
```typescript
PATCH /v2/entities/{id}/attrs
Content-Type: application/json
```

#### Eliminar un producto
```typescript
DELETE /v2/entities/{id}
```

### Proxy de Vite

Las peticiones `/v2/*` del frontend se redirigen a Orion a través del proxy de Vite, evitando problemas de CORS:

```typescript
// vite.config.ts
server: {
  proxy: {
    '/v2': {
      target: 'http://localhost:1026',
      changeOrigin: true,
    },
  },
},
```

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

---

### `ProductTable`

Muestra los productos en una tabla con acciones de editar y eliminar.

```typescript
interface Props {
  products: Product[]
  onEdit: (product: Product) => void
  onDelete: (id: string) => void
}
```

---

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

---

### `Modal`

Contenedor modal genérico y reutilizable.

```typescript
interface Props {
  title: string
  children: React.ReactNode
  onClose: () => void
}
```

Ejemplo de uso:

```tsx
<Modal title="Nuevo producto" onClose={() => setShowForm(false)}>
  <ProductForm onSubmit={handleCreate} onCancel={() => setShowForm(false)} />
</Modal>
```

---

## Estilos

Tailwind CSS v4 con directivas `@apply`. Cada componente tiene su propio `.css` y todos se importan desde `index.css`:

```css
/* src/index.css */
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

`NgsiEntity` representa la estructura real que devuelve y acepta la API de Orion. Las funciones `toProduct` y `toNgsi` en `orion.ts` se encargan de convertir entre ambos formatos.
