export interface Transaction {
  id?: number;
  date?: string | Date;
  transactionType: 'compra' | 'venta';
  productId: number;
  quantity: number;
  unitPrice: number;
  detail: string;
  totalPrice?: number;
}
