import { useState, useEffect, useCallback, useRef } from 'react'
import type { Product, PedidoItem } from './types'
import * as orion from './services/orion'
import keycloak from './services/keycloak'
import ProductTable from './components/ProductTable'
import ProductForm from './components/ProductForm'
import PedidoTable from './components/PedidoTable'
import Toast from './components/Toast'
import Modal from './components/Modal'

type Section = 'inventario' | 'pedido'

const SECTIONS: { id: Section; label: string }[] = [
  { id: 'inventario', label: 'Inventario' },
  { id: 'pedido',     label: 'Pedido' },
]

function loadPedido(): PedidoItem[] {
  try {
    const saved = localStorage.getItem('pedido')
    return saved ? JSON.parse(saved) : []
  } catch {
    return []
  }
}

export default function App() {
  const [products, setProducts]   = useState<Product[]>([])
  const [loading, setLoading]     = useState(true)
  const [error, setError]         = useState<string | null>(null)
  const [showForm, setShowForm]   = useState(false)
  const [editing, setEditing]     = useState<Product | null>(null)
  const [pedido, setPedido]       = useState<PedidoItem[]>(loadPedido)
  const [section, setSection]     = useState<Section>('inventario')
  const [toast, setToast]         = useState<string | null>(null)
  const [toastKey, setToastKey]   = useState(0)
  const toastTimer                = useRef<ReturnType<typeof setTimeout> | null>(null)

  const username     = keycloak.tokenParsed?.preferred_username ?? ''
  const isBasicoPapa = keycloak.hasRealmRole('BasicoPapa')

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

  useEffect(() => {
    localStorage.setItem('pedido', JSON.stringify(pedido))
  }, [pedido])

  function showToast(message: string) {
    if (toastTimer.current) clearTimeout(toastTimer.current)
    setToast(message)
    setToastKey(k => k + 1)
    toastTimer.current = setTimeout(() => setToast(null), 2000)
  }

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

  async function handleQuantityChange(id: string, delta: number) {
    const product = products.find(p => p.id === id)
    if (!product) return
    await orion.updateQuantity(id, Math.max(0, product.quantity + delta))
    load()
  }

  async function handleDelete(id: string) {
    if (!confirm('¿Eliminar este producto?')) return
    await orion.deleteProduct(id)
    load()
  }

  function handleAddPedido(id: string) {
    const product = products.find(p => p.id === id)
    if (!product) return
    setPedido(prev => {
      const existing = prev.find(item => item.productId === id)
      if (existing) {
        return prev.map(item => item.productId === id ? { ...item, quantity: item.quantity + 1 } : item)
      }
      return [...prev, { productId: id, name: product.name, quantity: 1 }]
    })
    showToast(`${product.name} añadido al pedido`)
  }

  function handleRemovePedido(productId: string) {
    const item = pedido.find(i => i.productId === productId)
    setPedido(prev => prev.filter(i => i.productId !== productId))
    if (item) showToast(`${item.name} eliminado del pedido`)
  }

  function handleQuantityChangePedido(productId: string, delta: number) {
    setPedido(prev => prev
      .map(item => item.productId === productId ? { ...item, quantity: item.quantity + delta } : item)
      .filter(item => item.quantity > 0)
    )
  }

  function handleSetQuantityPedido(productId: string, quantity: number) {
    setPedido(prev => prev.map(item => item.productId === productId ? { ...item, quantity } : item))
  }

  return (
    <div className="app">
      <header className="app-header">
        <div className="app-header-inner">
          <div>
            <p className="app-header-section">Apartado</p>
            <h1 className="app-header-title">{SECTIONS.find(s => s.id === section)?.label}</h1>
          </div>
          <div className="flex items-center gap-4">
            <span className="app-header-user">{username}</span>
            <button onClick={() => keycloak.logout()} className="app-header-logout">
              Cerrar sesión
            </button>
          </div>
        </div>
      </header>

      <nav className="app-nav">
        <div className="app-nav-inner">
          {SECTIONS.map(s => (
            <button
              key={s.id}
              onClick={() => setSection(s.id)}
              className={`app-nav-btn ${section === s.id ? 'app-nav-btn-active' : ''}`}
            >
              {s.label}
            </button>
          ))}
        </div>
      </nav>

      <main className="app-main">
        {loading && <p className="app-loading">Cargando...</p>}
        {error && <p className="app-error">{error}</p>}
        {!loading && !error && (
          <>
            {section === 'inventario' && (
              <>
                <div className="app-section-toolbar">
                  <h2 className="app-section-title">Productos</h2>
                  <button onClick={() => setShowForm(true)} className="app-header-btn">
                    + Añadir producto
                  </button>
                </div>
                <ProductTable
                  products={products}
                  onEdit={setEditing}
                  onDelete={handleDelete}
                  onQuantityChange={handleQuantityChange}
                  onAddPedido={handleAddPedido}
                  isBasicoPapa={isBasicoPapa}
                />
              </>
            )}

            {section === 'pedido' && (
              <PedidoTable
                items={pedido}
                products={products}
                onRemove={handleRemovePedido}
                onQuantityChange={handleQuantityChangePedido}
                onSetQuantity={handleSetQuantityPedido}
                onAdd={handleAddPedido}
                onClear={() => setPedido([])}
                isBasicoPapa={isBasicoPapa}
                showEmpty
              />
            )}
          </>
        )}
      </main>

      {toast && <Toast key={toastKey} message={toast} />}

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
