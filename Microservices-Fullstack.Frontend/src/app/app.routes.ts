import { Routes } from '@angular/router';
import { ProductComponent } from './features/product/product.component';
import { ProductListComponent } from './features/product/product-list/product-list.component';
import { TransactionComponent } from './features/transaction/transaction.component';
import { TransactionListComponent } from './features/transaction/transaction-list/transaction-list.component';

export const appRoutes: Routes = [
  
  // CRUD de productos
  { path: 'products', component: ProductListComponent },
  { path: 'products/create', component: ProductComponent },
  { path: 'products/edit/:id', component: ProductComponent },
  { path: 'products/:id', component: ProductComponent },

  { path: 'transactions', component: TransactionListComponent },
  { path: 'transactions/create', component: TransactionComponent },
  { path: 'transactions/edit/:id', component: TransactionComponent },

  // 404 fallback
  { path: '**', redirectTo: '' },

];
