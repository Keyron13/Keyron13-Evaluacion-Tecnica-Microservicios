using System.Net.Http.Json;
using TransactionService.Controllers;
using TransactionService.Entities;
using TransactionService.Repositories;

namespace TransactionService.Services
{
    public class TransactionService : ITransactionService
    {
        private readonly ITransactionRepository _repository;
        private readonly HttpClient _httpClient;

        public TransactionService(ITransactionRepository repository, IHttpClientFactory httpClientFactory)
        {
            _repository = repository;
            _httpClient = httpClientFactory.CreateClient("ProductApi");
        }

        public async Task<IEnumerable<Transaction>> GetAllTransactionsAsync()
        {
            return await _repository.GetAllTransactionsAsync();
        }

        public async Task<IEnumerable<Transaction>> GetAllAsync(DateTime? start, DateTime? end, string? type)
        {
            return await _repository.GetAllAsync(start, end, type);
        }

        public async Task<Transaction?> GetByIdAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }

        public async Task<TransactionResult> CreateAsync(TransactionCreateDto dto)
        {
            try
            {
                // Validación del tipo de transacción
                if (dto.TransactionType.ToLower() != "compra" && dto.TransactionType.ToLower() != "venta")
                    return new TransactionResult("Tipo de transacción inválido. Debe ser 'compra' o 'venta'");

                // Obtener el producto
                var productResponse = await _httpClient.GetAsync($"api/products/{dto.ProductId}");
                if (!productResponse.IsSuccessStatusCode)
                    return new TransactionResult("Producto no encontrado");

                var product = await productResponse.Content.ReadFromJsonAsync<Product>();

                // Validar stock para ventas
                if (dto.TransactionType.ToLower() == "venta" && dto.Quantity > product.Stock)
                    return new TransactionResult($"Stock insuficiente. Disponible: {product.Stock}, Solicitado: {dto.Quantity}");

                // Crear la transacción
                var transaction = new Transaction
                {
                    TransactionType = dto.TransactionType,
                    ProductId = dto.ProductId,
                    Quantity = dto.Quantity,
                    UnitPrice = dto.UnitPrice,
                    Detail = dto.Detail,
                    Date = DateTime.UtcNow
                };

                // Guardar transacción
                var createdTransaction = await _repository.CreateAsync(transaction);

                // Actualizar stock del producto
                var stockUpdate = new
                {
                    Quantity = dto.TransactionType.ToLower() == "compra" ? dto.Quantity : -dto.Quantity,
                    NewPrice = dto.TransactionType.ToLower() == "compra" ? dto.UnitPrice : (decimal?)null
                };

                var updateResponse = await _httpClient.PatchAsJsonAsync(
                    $"api/products/{dto.ProductId}/stock",
                    stockUpdate);

                if (!updateResponse.IsSuccessStatusCode)
                    return new TransactionResult("Error al actualizar el stock del producto");

                return new TransactionResult("Transacción creada con éxito", createdTransaction);
            }
            catch (Exception ex)
            {
                return new TransactionResult($"Error al crear la transacción: {ex.Message}");
            }
        }

        // Método para actualizar transacción
        public async Task<TransactionResult> UpdateTransactionAsync(TransactionUpdateDto dto)
        {
            // Validar tipo de transacción
            if (dto.TransactionType.ToLower() != "compra" && dto.TransactionType.ToLower() != "venta")
                return new TransactionResult("Tipo de transacción inválido");

            // Obtener transacción existente
            var existingTransaction = await _repository.GetByIdAsync(dto.Id);
            if (existingTransaction == null)
                return new TransactionResult("Transacción no encontrada");

            // Obtener producto
            var productResponse = await _httpClient.GetAsync($"api/products/{dto.ProductId}");
            if (!productResponse.IsSuccessStatusCode)
                return new TransactionResult("Producto no encontrado");

            var product = await productResponse.Content.ReadFromJsonAsync<Product>();

            // Calcular diferencia de stock
            var stockDifference = CalculateStockDifference(
                existingTransaction,
                dto.TransactionType,
                dto.Quantity);

            // Validar stock para ventas
            if (dto.TransactionType.ToLower() == "venta" && (product.Stock + stockDifference) < 0)
                return new TransactionResult("Stock insuficiente para esta modificación");

            // Actualizar transacción
            existingTransaction.TransactionType = dto.TransactionType;
            existingTransaction.ProductId = dto.ProductId;
            existingTransaction.Quantity = dto.Quantity;
            existingTransaction.UnitPrice = dto.UnitPrice;
            existingTransaction.Detail = dto.Detail;

            var updatedTransaction = await _repository.UpdateAsync(existingTransaction);

            // Actualizar stock del producto
            var stockUpdate = new
            {
                Quantity = stockDifference,
                NewPrice = dto.TransactionType.ToLower() == "compra" ? dto.UnitPrice : (decimal?)null
            };

            var updateResponse = await _httpClient.PatchAsJsonAsync(
                $"api/products/{dto.ProductId}/stock",
                stockUpdate);

            if (!updateResponse.IsSuccessStatusCode)
                return new TransactionResult("Error al actualizar el stock del producto");

            return new TransactionResult("Transacción actualizada con éxito", updatedTransaction);
        }

        // Método para eliminar transacción
        public async Task<TransactionResult> DeleteTransactionAsync(int id)
        {
            var transaction = await _repository.GetByIdAsync(id);
            if (transaction == null)
                return new TransactionResult("Transacción no encontrada");

            // Obtener producto
            var productResponse = await _httpClient.GetAsync($"api/products/{transaction.ProductId}");
            if (!productResponse.IsSuccessStatusCode)
                return new TransactionResult("Producto no encontrado");

            // Calcular reversión de stock
            var stockRevert = transaction.TransactionType.ToLower() == "compra"
                ? -transaction.Quantity
                : transaction.Quantity;

            // Eliminar transacción
            await _repository.DeleteAsync(id);

            // Revertir stock
            var stockUpdate = new { Quantity = stockRevert };
            var updateResponse = await _httpClient.PatchAsJsonAsync(
                $"api/products/{transaction.ProductId}/stock",
                stockUpdate);

            if (!updateResponse.IsSuccessStatusCode)
                return new TransactionResult("Error al revertir el stock del producto");

            // ✅ Éxito sin mensaje (o con mensaje si lo usas para logging)
            return new TransactionResult
            {
                Success = true
            };
        }


        // Método auxiliar para calcular diferencia de stock
        private int CalculateStockDifference(Transaction existing, string newType, int newQuantity)
        {
            var oldEffect = existing.TransactionType.ToLower() == "compra"
                ? existing.Quantity
                : -existing.Quantity;

            var newEffect = newType.ToLower() == "compra"
                ? newQuantity
                : -newQuantity;

            return newEffect - oldEffect;
        }

        public class Product
        {
            public int Id { get; set; }
            public int Stock { get; set; }
            public decimal Price { get; set; }
        }


    }
}