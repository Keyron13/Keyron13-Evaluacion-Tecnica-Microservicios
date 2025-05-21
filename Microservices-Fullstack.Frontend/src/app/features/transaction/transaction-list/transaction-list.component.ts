import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { TransactionService } from '../../../core/services/api/transaction.service';
import { Transaction } from '../../../core/models/Transaction.interface';
import { ProductService } from '../../../core/services/api/product.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-transaction-list',
  templateUrl: './transaction-list.component.html',
  styleUrl: './transaction-list.component.scss',
  standalone: true,
  imports: [CommonModule, FormsModule],
})
export class TransactionListComponent implements OnInit {
  transactions: Transaction[] = [];
  productsMap = new Map<number, string>(); // Mapa para id->nombre producto
  loading = true;

  searchText: string = '';
  selectedType: string = ''; // '', 'venta', 'compra'

  // Paginación
  currentPage: number = 1;
  itemsPerPage: number = 5;

  constructor(
    private transactionService: TransactionService,
    private productService: ProductService,
    public router: Router
  ) {}

  ngOnInit(): void {
    this.loadProducts();
  }

  loadProducts() {
    this.productService.getAll().subscribe({
      next: (products) => {
        products.forEach(p => this.productsMap.set(p.id!, p.name));
        this.loadTransactions();
      },
      error: () => {
        alert('Error al cargar productos');
        this.loading = false;
      }
    });
  }

  loadTransactions() {
    this.loading = true;
    this.transactionService.getAll().subscribe({
      next: (data) => {
        this.transactions = data;
        this.loading = false;
      },
      error: () => {
        alert('Error al cargar transacciones');
        this.loading = false;
      }
    });
  }

  getProductName(productId: number): string {
    return this.productsMap.get(productId) || 'Producto desconocido';
  }

  editTransaction(id: number) {
    this.router.navigate(['/transactions/edit', id]);
  }

  deleteTransaction(id: number) {
    if (!confirm('¿Estás seguro de eliminar esta transacción?')) return;
    this.transactionService.delete(id).subscribe({
      next: () => this.loadTransactions(),
      error: () => alert('Error al eliminar la transacción'),
    });
  }

  navigateToHome() {
    this.router.navigate(['/']); // Ajusta la ruta principal según tu configuración
  }

  filteredTransactions(): Transaction[] {
    return this.transactions.filter(t =>
      this.getProductName(t.productId).toLowerCase().includes(this.searchText.toLowerCase()) &&
      (this.selectedType === '' || t.transactionType === this.selectedType)
    );
  }

  paginatedTransactions(): Transaction[] {
    const start = (this.currentPage - 1) * this.itemsPerPage;
    return this.filteredTransactions().slice(start, start + this.itemsPerPage);
  }

  totalPages(): number {
    return Math.ceil(this.filteredTransactions().length / this.itemsPerPage);
  }

  goToPage(page: number): void {
    if (page < 1 || page > this.totalPages()) return;
    this.currentPage = page;
  }
}
