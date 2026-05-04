import type { Product, NgsiEntity } from '../types'
import keycloak from './keycloak'

const BASE = '/v2'
const ENTITY_TYPE = 'InventoryItem'

function headers(extra: Record<string, string> = {}): Record<string, string> {
  const userId = (keycloak.tokenParsed?.sub ?? 'anonymous').replace(/-/g, '')
  return {
    'Authorization': `Bearer ${keycloak.token}`,
    'Fiware-Service': `user${userId}`.slice(0, 50),
    'Fiware-ServicePath': '/',
    ...extra,
  }
}

function toProduct(entity: NgsiEntity): Product {
  return {
    id: entity.id,
    name: entity.name.value,
    category: entity.category.value,
    quantity: entity.quantity.value,
    unit: entity.unit.value,
    price: entity.price.value,
  }
}

function toNgsi(product: Omit<Product, 'id'>): Omit<NgsiEntity, 'id' | 'type'> {
  return {
    name: { type: 'Text', value: product.name },
    category: { type: 'Text', value: product.category },
    quantity: { type: 'Number', value: product.quantity },
    unit: { type: 'Text', value: product.unit },
    price: { type: 'Number', value: product.price },
  }
}

export async function getProducts(): Promise<Product[]> {
  const res = await fetch(`${BASE}/entities?type=${ENTITY_TYPE}&limit=100`, {
    headers: headers(),
  })
  if (!res.ok) {
    const body = await res.text().catch(() => '')
    throw new Error(`Orion ${res.status}: ${body}`)
  }
  const entities: NgsiEntity[] = await res.json()
  return entities.map(toProduct)
}

export async function createProduct(product: Omit<Product, 'id'>): Promise<void> {
  const id = `urn:ngsi-ld:InventoryItem:${Date.now()}`
  const body = { id, type: ENTITY_TYPE, ...toNgsi(product) }
  const res = await fetch(`${BASE}/entities`, {
    method: 'POST',
    headers: headers({ 'Content-Type': 'application/json' }),
    body: JSON.stringify(body),
  })
  if (!res.ok) throw new Error('Error al crear producto')
}

export async function updateProduct(id: string, product: Omit<Product, 'id'>): Promise<void> {
  const res = await fetch(`${BASE}/entities/${id}/attrs`, {
    method: 'PATCH',
    headers: headers({ 'Content-Type': 'application/json' }),
    body: JSON.stringify(toNgsi(product)),
  })
  if (!res.ok) throw new Error('Error al actualizar producto')
}

export async function deleteProduct(id: string): Promise<void> {
  const res = await fetch(`${BASE}/entities/${id}`, {
    method: 'DELETE',
    headers: headers(),
  })
  if (!res.ok) throw new Error('Error al eliminar producto')
}
