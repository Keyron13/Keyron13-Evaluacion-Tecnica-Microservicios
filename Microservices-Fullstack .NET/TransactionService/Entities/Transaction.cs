namespace TransactionService.Entities
{
    public class Transaction
    {
        public int Id { get; set; }
        public DateTime Date { get; set; } = DateTime.UtcNow;
        public string TransactionType { get; set; } // "compra" o "venta"
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice => UnitPrice * Quantity; // Calculado automáticamente
        public string Detail { get; set; }
    }
}

