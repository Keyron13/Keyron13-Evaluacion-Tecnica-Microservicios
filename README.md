# Sistema de Inventario - Documentación Técnica

## 🔧 Instalación Backend (.NET 8)

## ✅ Requisitos

Para ejecutar este proyecto en un entorno local necesitas:

- [.NET 7.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/7.0)
- [Node.js (v18+)](https://nodejs.org/)
- [Angular CLI](https://angular.io/cli)
- [SQL Server](https://www.microsoft.com/en-us/sql-server)
- Visual Studio Code o Visual Studio 2022
- Git

---

###  📚 Tecnologías utilizadas

| Tecnología       | Uso                           |
| ---------------- | ----------------------------- |
| ASP.NET Core     | Microservicios backend        |
| Angular 15+      | Aplicación frontend SPA       |
| SQL Server       | Base de datos relacional      |
| Bootstrap 5      | Estilos y diseño web          |
| Angular Material | Componentes de UI (snackbars) |
| RxJS             | Manejo de datos reactivo      |
| REST API         | Comunicación HTTP             |


### Configuración inicial:
```bash
git clone https://github.com/tu-usuario/inventory-system.git
cd inventory-system/backend
```

### Base de datos:
1. Ejecutar script SQL:

```json
  -- Ejecutar el scripts Script-InventoryMicroservicesDb.sql 
```

2. Configurar conexión:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=InventoryServiceDB;User Id=sa;Password=TuContraseña;TrustServerCertificate=true;"
  }
  //Seccion para TransactionService
  "ProductServiceUrl": "https://localhost:7031/", // Debe coincidir con la URL real del ProductService
}
```

### Servicios:

#### ProductService:
```bash
cd src/ProductService
dotnet restore
dotnet ef database update
dotnet run --urls=https://localhost:7111
```

#### TransactionService:
```bash
cd src/TransactionService
dotnet restore
dotnet ef database update
dotnet run --urls=https://localhost:7168
```

## 🖥 Frontend (Angular 18)

### Instalación:
```bash
cd ../frontend
npm install -g @angular/cli@latest
npm install
```

### Variables de entorno:
```typescript
// environment.prod.ts
export const environment = {
  production: true,
  apiUrls: {
    products: 'https://localhost:7111/api',
    transactions: 'https://localhost:7168/api'
  }
};
```

### Ejecución:
```bash
ng serve --port 4200 --open
```

## ✅ Evidencias de Configuración

### Backend:

- ✅ Swagger operativo en /swagger  

![Swagger](Images/Backend-Apis.png)

- ✅ Pruebas unitarias EndPoint  

![Obtener Lista backend](Images/Backend-Apis-ObtenerLista.png)

### Frontend:
- ✅ Console de producción sin errores  

![producción](Images/Console.png)

- ✅ Conexión con APIs verificada  

![APIs](Images/Rutas frontend.png)



##  🧪 Evidencias
Agrega capturas de pantalla que demuestren la funcionalidad del sistema:

 ✅ Página principal

 ![Pagina Principal](Images/Pagina-principal.png)

 ✅ Listado dinámico de productos con paginación

  ![Listado dinámico de productos](Images/Enlistar-Productos.png)

 ✅ Listado dinámico de transacciones con paginación

  ![Listado dinámico de transacciones](Images/Enlistar-Transaccion.png)

 ✅ Pantalla de creación de productos

  ![creación de productos](Images/Crear-Producto.png)

 ✅ Pantalla de edición de productos

   ![edición de productos](Images/Editar-Producto.png)

 ✅ Pantalla de creación de transacciones

   ![creación de transacciones](Images/Crear-Transaccion.png)

 ✅ Pantalla de edición de transacciones

   ![edición de transacciones](Images/Editar-Transaccion.png)

 ✅ Pantalla de filtros dinámicos

   - Tabla Producto

   ![Por categoria](Images/FiltrarCategoria-Producto.png)

   ![Por Nombre](Images/FiltrarNombre-Producto.png)

   - Tabla Transacción

   ![Por Tipo de transacción](Images/FiltrarTipoTransaccion-Transaccion.png)

   ![Por Nombre](Images/FiltrarNombre-Transaccion.png)


## 🚀 Despliegue

### SQL Server (Backend):
- Tabla Producto

![Tabla Producto](Images/Tabla_Producto_DB.png)

- Tabla Transacción

![Tabla Producto](Images/Tabla_Transaccion_DB.png)


## 📌 Autor
Desarrollado como parte de una evaluación técnica full stack .NET + Angular por KEYRON AGUILAR.