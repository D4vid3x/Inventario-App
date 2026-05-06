import type { Product } from '../types'

interface Props {
  products: Product[]
  onEdit: (product: Product) => void
  onDelete: (id: string) => void
  onQuantityChange: (id: string, delta: number) => void
  onAddPedido: (id: string) => void
  isBasicoPapa: boolean
}

export default function ProductTable({ products, onEdit, onDelete, onQuantityChange, onAddPedido, isBasicoPapa }: Props) {
  if (products.length === 0) {
    return (
      <p className="table-empty">
        No hay productos. Añade el primero con el botón de arriba.
      </p>
    )
  }

  return (
    <div className="table-wrapper">
      <table className="table">
        <thead className="table-head">
          <tr>
            <th className="table-th">Nombre</th>
            {!isBasicoPapa && <th className="table-th">Categoría</th>}
            <th className="table-th">Cantidad</th>
            {!isBasicoPapa && <th className="table-th">Unidad</th>}
            {!isBasicoPapa && <th className="table-th">Precio (€)</th>}
            <th className="table-th">Acciones</th>
          </tr>
        </thead>
        <tbody className="table-body">
          {products.map(p => (
            <tr key={p.id} className="table-row">
              <td className="table-td-name">{p.name}</td>
              {!isBasicoPapa && <td className="table-td">{p.category}</td>}
              <td className="table-td">
                <div className="table-actions">
                  <button onClick={() => onQuantityChange(p.id, -1)} className="btn-quantity" disabled={p.quantity <= 0}>−</button>
                  <span>{p.quantity}</span>
                  <button onClick={() => onQuantityChange(p.id, 1)} className="btn-quantity">+</button>
                </div>
              </td>
              {!isBasicoPapa && <td className="table-td">{p.unit}</td>}
              {!isBasicoPapa && <td className="table-td">{p.price.toFixed(2)}</td>}
              <td className="table-td">
                <div className="table-actions">
                  <button onClick={() => onEdit(p)} className="btn-edit">Editar</button>
                  <button onClick={() => onDelete(p.id)} className="btn-delete">Eliminar</button>
                  <button onClick={() => onAddPedido(p.id)} className="btn-addPedido">Añarir al pedido</button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
