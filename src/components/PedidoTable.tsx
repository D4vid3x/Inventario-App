import { useState } from 'react'
import type { PedidoItem, Product } from '../types'

interface Props {
  items: PedidoItem[]
  products: Product[]
  onRemove: (productId: string) => void
  onQuantityChange: (productId: string, delta: number) => void
  onSetQuantity: (productId: string, quantity: number) => void
  onAdd: (id: string) => void
  onClear: () => void
  isBasicoPapa: boolean
  showEmpty?: boolean
}

function formatPedido(items: PedidoItem[]): string {
  const fecha = new Date().toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' })
  const lineas = items.map(item => `• ${item.name} x${item.quantity}`).join('\n')
  return `📋 Pedido ${fecha}\n\n${lineas}`
}

async function sharePedido(items: PedidoItem[]) {
  const text = formatPedido(items)
  if (navigator.share) {
    await navigator.share({ text })
  } else {
    window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, '_blank')
  }
}

export default function PedidoTable({ items, products, onRemove, onQuantityChange, onSetQuantity, onAdd, onClear, isBasicoPapa, showEmpty }: Props) {
  const [selectedId, setSelectedId] = useState('')
  const [editingId, setEditingId] = useState<string | null>(null)
  const [editValue, setEditValue] = useState('')

  function handleAdd() {
    if (!selectedId) return
    onAdd(selectedId)
    setSelectedId('')
  }

  function startEdit(item: PedidoItem) {
    setEditingId(item.productId)
    setEditValue(String(item.quantity))
  }

  function saveEdit(productId: string) {
    const qty = parseInt(editValue)
    if (!isNaN(qty) && qty > 0) onSetQuantity(productId, qty)
    setEditingId(null)
  }

  const addRow = (
    <div className="pedido-add-row">
      <select value={selectedId} onChange={e => setSelectedId(e.target.value)} className="pedido-select">
        <option value="">Selecciona un producto...</option>
        {products.map(p => (
          <option key={p.id} value={p.id}>{p.name}</option>
        ))}
      </select>
      <button onClick={handleAdd} disabled={!selectedId} className="pedido-btn-add">Añadir</button>
    </div>
  )

  if (items.length === 0 && !showEmpty) return null
  if (items.length === 0) return (
    <div className="pedido-wrapper">
      <div className="pedido-header"><h2 className="pedido-title">Pedido</h2></div>
      {addRow}
      <p className="table-empty">No hay productos en el pedido.</p>
    </div>
  )

  return (
    <div className="pedido-wrapper">
      <div className="pedido-header">
        <h2 className="pedido-title">Pedido</h2>
        <div className="table-actions">
          {isBasicoPapa && <button onClick={() => sharePedido(items)} className="pedido-btn-share">Compartir</button>}
          <button onClick={onClear} className="pedido-btn-clear">Vaciar</button>
        </div>
      </div>
      {addRow}
      <table className="pedido-table">
        <thead className="pedido-thead">
          <tr>
            <th className="pedido-th">Producto</th>
            <th className="pedido-th">Cantidad</th>
            <th className="pedido-th"></th>
          </tr>
        </thead>
        <tbody>
          {items.map(item => (
            <tr key={item.productId} className="pedido-row">
              <td className="pedido-td">{item.name}</td>
              <td className="pedido-td">
                {editingId === item.productId ? (
                  <div className="table-actions">
                    <input
                      type="number"
                      min="1"
                      value={editValue}
                      onChange={e => setEditValue(e.target.value)}
                      onKeyDown={e => e.key === 'Enter' && saveEdit(item.productId)}
                      className="pedido-qty-input"
                      autoFocus
                    />
                    <button onClick={() => saveEdit(item.productId)} className="pedido-btn-save">Guardar</button>
                  </div>
                ) : (
                  <div className="table-actions">
                    <button onClick={() => onQuantityChange(item.productId, -1)} className="btn-quantity">−</button>
                    <span>{item.quantity}</span>
                    <button onClick={() => onQuantityChange(item.productId, 1)} className="btn-quantity">+</button>
                  </div>
                )}
              </td>
              <td className="pedido-td">
                <div className="table-actions">
                  <button onClick={() => startEdit(item)} className="btn-edit">Editar</button>
                  <button onClick={() => onRemove(item.productId)} className="pedido-btn-remove">✕</button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
