import type { PedidoItem } from '../types'

interface Props {
  items: PedidoItem[]
  onRemove: (productId: string) => void
  onQuantityChange: (productId: string, delta: number) => void
  onClear: () => void
  showEmpty?: boolean
}

export default function PedidoTable({ items, onRemove, onQuantityChange, onClear, showEmpty }: Props) {
  if (items.length === 0 && !showEmpty) return null
  if (items.length === 0) return <p className="table-empty">No hay productos en el pedido.</p>

  return (
    <div className="pedido-wrapper">
      <div className="pedido-header">
        <h2 className="pedido-title">Pedido</h2>
        <button onClick={onClear} className="pedido-btn-clear">Vaciar</button>
      </div>
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
                <div className="table-actions">
                  <button onClick={() => onQuantityChange(item.productId, -1)} className="btn-quantity">−</button>
                  <span>{item.quantity}</span>
                  <button onClick={() => onQuantityChange(item.productId, 1)} className="btn-quantity">+</button>
                </div>
              </td>
              <td className="pedido-td">
                <button onClick={() => onRemove(item.productId)} className="pedido-btn-remove">✕</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
