import { useState, useEffect } from 'react'
import type { Product } from '../types'

const UNITS = ['kg', 'Manojo', 'Caja']
const CATEGORIES = ['Frutas', 'Verduras', 'Hortalizas']

interface Props {
  initial?: Product
  onSubmit: (data: Omit<Product, 'id'>) => void
  onCancel: () => void
}

export default function ProductForm({ initial, onSubmit, onCancel }: Props) {
  const [form, setForm] = useState({
    name: '',
    category: CATEGORIES[0],
    quantity: 0,
    unit: UNITS[0],
    price: 0,
  })

  useEffect(() => {
    if (initial) {
      setForm({
        name: initial.name,
        category: initial.category,
        quantity: initial.quantity,
        unit: initial.unit,
        price: initial.price,
      })
    }
  }, [initial])

  function handleChange(e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) {
    const { name, value } = e.target
    setForm(f => ({
      ...f,
      [name]: name === 'quantity' || name === 'price' ? Number(value) : value,
    }))
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    onSubmit(form)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="form-grid">
        <div className="col-span-2">
          <label className="form-label">Nombre</label>
          <input name="name" value={form.name} onChange={handleChange} required
            placeholder="Ej. Manzana roja" className="form-input" />
        </div>
        <div>
          <label className="form-label">Categoría</label>
          <select name="category" value={form.category} onChange={handleChange} className="form-input">
            {CATEGORIES.map(c => <option key={c}>{c}</option>)}
          </select>
        </div>
        <div>
          <label className="form-label">Unidad</label>
          <select name="unit" value={form.unit} onChange={handleChange} className="form-input">
            {UNITS.map(u => <option key={u}>{u}</option>)}
          </select>
        </div>
        <div>
          <label className="form-label">Cantidad</label>
          <input type="number" name="quantity" value={form.quantity} onChange={handleChange} min={0} required className="form-input" />
        </div>
        <div>
          <label className="form-label">Precio (€)</label>
          <input type="number" name="price" value={form.price} onChange={handleChange} min={0} step={0.01} required className="form-input" />
        </div>
      </div>
      <div className="form-actions">
        <button type="button" onClick={onCancel} className="btn-cancel">Cancelar</button>
        <button type="submit" className="btn-submit">
          {initial ? 'Guardar cambios' : 'Añadir producto'}
        </button>
      </div>
    </form>
  )
}
