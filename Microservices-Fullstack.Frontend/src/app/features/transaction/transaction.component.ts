import { Component, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TransactionService } from '../../core/services/api/transaction.service';
import { Product } from '../../core/models/Product.interface';
import { ProductService } from '../../core/services/api/product.service';
import { Transaction } from '../../core/models/Transaction.interface';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-transaction-form',
  templateUrl: './transaction.component.html',
  styleUrls: ['./transaction.component.scss'],
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule],
})
export class TransactionComponent implements OnInit {
  transactionForm: FormGroup;
  products: Product[] = [];
  isEditMode = false;
  transactionId?: number;

  constructor(
    private fb: FormBuilder,
    private transactionService: TransactionService,
    private productService: ProductService,
    private route: ActivatedRoute,
    public router: Router,
    private snackBar: MatSnackBar
  ) {
    this.transactionForm = this.fb.group({
      transactionType: ['', Validators.required],
      productId: [null, Validators.required],
      quantity: [1, [Validators.required, Validators.min(1)]],
      unitPrice: [0, [Validators.required, Validators.min(0.01)]],
      date: ['', Validators.required],
      detail: [''],
    });
  }

  ngOnInit(): void {
    this.loadProducts();

    this.route.paramMap.subscribe((params) => {
      const idParam = params.get('id');
      if (idParam) {
        this.transactionId = +idParam;
        this.isEditMode = true;
        this.loadTransaction(this.transactionId);
      }
    });

    this.transactionForm
      .get('productId')
      ?.valueChanges.subscribe((productId) => {
        const selectedProduct = this.products.find((p) => p.id === +productId);
        if (selectedProduct) {
          this.transactionForm
            .get('unitPrice')
            ?.setValue(selectedProduct.price, { emitEvent: false });
        } else {
          this.transactionForm
            .get('unitPrice')
            ?.setValue(0, { emitEvent: false });
        }
      });
  }

  loadProducts(): void {
    this.productService.getAll().subscribe((products) => {
      this.products = products;
      console.log('Productos cargados:', this.products);
    });
  }

  loadTransaction(id: number): void {
  this.transactionService.getById(id).subscribe((transaction) => {
    let formattedDate = '';

    if (transaction.date) {
      // Si es string, hacemos split, si es Date lo convertimos a ISO primero
      if (typeof transaction.date === 'string') {
        formattedDate = transaction.date.split('T')[0];
      } else if (transaction.date instanceof Date) {
        formattedDate = transaction.date.toISOString().split('T')[0];
      } else {
        // si viene en otro formato (ej: JSON Date), convertir a string primero
        formattedDate = new Date(transaction.date).toISOString().split('T')[0];
      }
    }

    this.transactionForm.patchValue({
      ...transaction,
      date: formattedDate
    });
  });
}


  onSubmit(): void {
  if (this.transactionForm.invalid) return;

  const formValue = this.transactionForm.getRawValue();
  console.log('Formulario enviado con:', formValue);

  const selectedProduct = this.products.find(
    (p) => p.id === +formValue.productId
  );
  if (!selectedProduct) {
    this.snackBar.open('Producto no encontrado', 'Cerrar', { duration: 3000 });
    return;
  }

  if (
    formValue.transactionType === 'venta' &&
    formValue.quantity > selectedProduct.stock
  ) {
    this.snackBar.open('Stock insuficiente para la venta', 'Cerrar', {
      duration: 3000,
    });
    return;
  }

  // ✅ Convertir fecha (yyyy-MM-dd) a formato ISO con hora
  const dateWithTime = new Date(formValue.date + 'T00:00:00');

  const transaction: Transaction = {
    id: this.transactionId,
    ...formValue,
    productId: +formValue.productId,
    unitPrice: formValue.unitPrice,
    totalPrice: formValue.unitPrice * formValue.quantity,
    date: dateWithTime.toISOString(),
  };

  console.log('Transacción a enviar:', transaction);

  if (this.isEditMode && this.transactionId) {
    this.transactionService.update(this.transactionId, transaction).subscribe({
      next: () => {
        this.snackBar.open('Transacción actualizada correctamente', 'Cerrar', {
          duration: 3000,
        });
        this.router.navigate(['/transactions']);
      },
      error: () => {
        this.snackBar.open('Error al actualizar la transacción', 'Cerrar', {
          duration: 3000,
        });
      },
    });
  } else {
    this.transactionService.create(transaction).subscribe({
      next: () => {
        this.snackBar.open('Transacción creada correctamente', 'Cerrar', {
          duration: 3000,
        });
        this.router.navigate(['/transactions']);
      },
      error: () => {
        this.snackBar.open('Error al crear la transacción', 'Cerrar', {
          duration: 3000,
        });
      },
    });
  }
}


}
