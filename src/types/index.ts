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

export interface PedidoItem {
  productId: string
  name: string
  quantity: number
}

export type Unit = 'kg' | 'Manojo' | 'Caja'
export type Category = string
