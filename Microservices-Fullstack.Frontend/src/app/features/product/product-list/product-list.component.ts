import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ProductService } from '../../../core/services/api/product.service';
import { Product } from '../../../core/models/Product.interface';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html',
  styleUrl: './product-list.component.scss',
  standalone: true,
  imports: [CommonModule, FormsModule],
})
export class ProductListComponent implements OnInit {
  products: Product[] = [];
  loading = true;

  searchText: string = '';
  searchCategory: string = '';

  // Variables para paginación
  currentPage: number = 1;
  itemsPerPage: number = 4;

  constructor(private productService: ProductService, public router: Router) {}

  ngOnInit(): void {
    this.loadProducts();
  }

  loadProducts() {
    this.loading = true;
    this.productService.getAll().subscribe({
      next: (data) => {
        this.products = data;
        this.loading = false;
      },
      error: () => {
        this.loading = false;
        alert('Error al cargar productos');
      },
    });
  }

  editProduct(id: number) {
    this.router.navigate(['/products/edit', id]);
  }

  deleteProduct(id: number) {
    if (!confirm('¿Estás seguro de eliminar este producto?')) return;
    this.productService.delete(id).subscribe({
      next: () => this.loadProducts(),
      error: () => alert('Error al eliminar el producto'),
    });
  }

  navigateToHome() {
    this.router.navigate(['/']); // Ajusta la ruta principal según tu configuración
  }

  filteredProducts(): Product[] {
    return this.products.filter((p) =>
      p.name.toLowerCase().includes(this.searchText.toLowerCase()) &&
      (this.searchCategory === '' ||
        p.category.toLowerCase() === this.searchCategory.toLowerCase())
    );
  }

  // Productos ya filtrados pero paginados
  paginatedProducts(): Product[] {
    const start = (this.currentPage - 1) * this.itemsPerPage;
    return this.filteredProducts().slice(start, start + this.itemsPerPage);
  }

  getAllCategories(): string[] {
    return Array.from(new Set(this.products.map((p) => p.category)));
  }

  totalPages(): number {
    return Math.ceil(this.filteredProducts().length / this.itemsPerPage);
  }

  goToPage(page: number) {
    if (page < 1 || page > this.totalPages()) return;
    this.currentPage = page;
  }
}
