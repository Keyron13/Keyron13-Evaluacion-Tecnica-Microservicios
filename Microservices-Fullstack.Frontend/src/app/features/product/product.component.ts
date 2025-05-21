import { Component, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ProductService } from '../../core/services/api/product.service';
import { Product } from '../../core/models/Product.interface';
import { MatSnackBar } from '@angular/material/snack-bar';
import { CommonModule } from '@angular/common';
import { NgSelectModule } from '@ng-select/ng-select';

@Component({
  selector: 'app-product-form',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss'],
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule, FormsModule, NgSelectModule],
})
export class ProductComponent implements OnInit {
  productForm!: FormGroup;
  productId?: number;
  isEditMode = false;
  categories: string[] = [];
  showCustomCategory = false;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    public router: Router,
    private productService: ProductService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.productId = Number(this.route.snapshot.paramMap.get('id'));
    this.isEditMode = !!this.productId;

    this.productForm = this.fb.group({
      name: ['', [Validators.required, Validators.minLength(2)]],
      description: ['', [Validators.maxLength(500)]],
      category: ['', Validators.required],
      imageUrl: ['', [Validators.pattern('https?://.+')]],
      price: [0, [Validators.required, Validators.min(0.01)]],
      stock: [0, [Validators.required, Validators.min(0)]],
    });

    this.loadCategories();

    if (this.isEditMode) {
      this.productService.getById(this.productId!).subscribe((product) => {
        this.productForm.patchValue(product);

        // Mostrar campo personalizado si la categoría no está en la lista
        if (!this.categories.includes(product.category)) {
          this.showCustomCategory = true;
        }
      });
    }
  }

  loadCategories(): void {
    this.productService.getAll().subscribe((products) => {
      const allCategories = products.map((p) => p.category);
      this.categories = Array.from(new Set(allCategories));
    });
  }

  onCategoryChange(event: Event): void {
    const selectElement = event.target as HTMLSelectElement;
    const selectedValue = selectElement.value;

    if (selectedValue === '__other__') {
      this.showCustomCategory = true;
      this.productForm.get('category')?.reset();
    } else {
      this.showCustomCategory = false;
      this.productForm.get('category')?.setValue(selectedValue);
    }
  }

  onSubmit(): void {
    if (this.productForm.invalid) return;

    const product: Product = {
      id: this.productId!,
      ...this.productForm.value,
    };

    const action = this.isEditMode
      ? this.productService.update(this.productId!, product)
      : this.productService.create(product);

    action.subscribe({
      next: () => {
        this.snackBar.open(
          `Producto ${
            this.isEditMode ? 'actualizado' : 'creado'
          } correctamente`,
          'Cerrar',
          { duration: 3000 }
        );
        this.router.navigate(['/products']);
      },
      error: () => {
        this.snackBar.open('Error al guardar el producto', 'Cerrar', {
          duration: 3000,
        });
      },
    });
  }
}
