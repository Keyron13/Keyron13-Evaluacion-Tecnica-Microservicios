
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Product } from '../../models/Product.interface';
import { StockUpdateDto } from '../../models/StockUpdateDto.interface';
 // Ajusta la ruta si es necesario

@Injectable({
  providedIn: 'root'
})
export class ProductService {
  private baseUrl = 'https://localhost:7031/api/Products';

  constructor(private http: HttpClient) {}

  getAll(category?: string): Observable<Product[]> {
    const url = category ? `${this.baseUrl}?category=${encodeURIComponent(category)}` : this.baseUrl;
    return this.http.get<Product[]>(url);
  }

  getById(id: number): Observable<Product> {
    return this.http.get<Product>(`${this.baseUrl}/${id}`);
  }

  create(product: Product): Observable<Product> {
    return this.http.post<Product>(this.baseUrl, product);
  }

  update(id: number, product: Product): Observable<Product> {
    return this.http.put<Product>(`${this.baseUrl}/${id}`, product);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  updateStock(id: number, dto: StockUpdateDto): Observable<Product> {
    return this.http.patch<Product>(`${this.baseUrl}/${id}/stock`, dto);
  }
}

