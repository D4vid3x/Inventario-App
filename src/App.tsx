import { useState, useEffect, useCallback } from 'react'
import type { Product } from './types'
import * as orion from './services/orion'
import keycloak from './services/keycloak'
import ProductTable from './components/ProductTable'
import ProductForm from './components/ProductForm'
import Modal from './components/Modal'

export default function App() {
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [showForm, setShowForm] = useState(false)
  const [editing, setEditing] = useState<Product | null>(null)

  const username = keycloak.tokenParsed?.preferred_username ?? ''

  const load = useCallback(async () => {
    try {
      setError(null)
      const data = await orion.getProducts()
      setProducts(data)
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Error desconocido')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => { load() }, [load])

  async function handleCreate(data: Omit<Product, 'id'>) {
    await orion.createProduct(data)
    setShowForm(false)
    load()
  }

  async function handleUpdate(data: Omit<Product, 'id'>) {
    if (!editing) return
    await orion.updateProduct(editing.id, data)
    setEditing(null)
    load()
  }

  async function handleDelete(id: string) {
    if (!confirm('¿Eliminar este producto?')) return
    await orion.deleteProduct(id)
    load()
  }

  return (
    <div className="app">
      <header className="app-header">
        <div className="app-header-inner">
          <div>
            <h1 className="app-header-title">Inventario</h1>
            <p className="app-header-subtitle">{username}</p>
          </div>
          <div className="flex items-center gap-3">
            <button onClick={() => setShowForm(true)} className="app-header-btn">
              + Añadir producto
            </button>
            <button onClick={() => keycloak.logout()} className="app-header-logout">
              Cerrar sesión
            </button>
          </div>
        </div>
      </header>

      <main className="app-main">
        {loading && <p className="app-loading">Cargando...</p>}
        {error && <p className="app-error">{error}</p>}
        {!loading && !error && (
          <ProductTable products={products} onEdit={setEditing} onDelete={handleDelete} />
        )}
      </main>

      {showForm && (
        <Modal title="Nuevo producto" onClose={() => setShowForm(false)}>
          <ProductForm onSubmit={handleCreate} onCancel={() => setShowForm(false)} />
        </Modal>
      )}

      {editing && (
        <Modal title="Editar producto" onClose={() => setEditing(null)}>
          <ProductForm initial={editing} onSubmit={handleUpdate} onCancel={() => setEditing(null)} />
        </Modal>
      )}
    </div>
  )
}
