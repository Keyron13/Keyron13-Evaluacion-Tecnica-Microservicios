using System.Collections.Generic;
using System.Threading.Tasks;
using TransactionService.Controllers;
using TransactionService.Entities;

namespace TransactionService.Services
{
    public interface ITransactionService
    {
        // Método existente con filtros
        Task<IEnumerable<Transaction>> GetAllAsync(DateTime? startDate, DateTime? endDate, string? type);

        // Nuevo método para obtener todas sin filtros
        Task<IEnumerable<Transaction>> GetAllTransactionsAsync();

        Task<Transaction?> GetByIdAsync(int id);
        Task<TransactionResult> CreateAsync(TransactionCreateDto dto);
        Task<TransactionResult> UpdateTransactionAsync(TransactionUpdateDto dto);
        Task<TransactionResult> DeleteTransactionAsync(int id);
    }

    public class TransactionResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public Transaction? Transaction { get; set; }

        public TransactionResult(string message)
        {
            Success = false;
            Message = message;
        }

        public TransactionResult(string message, Transaction transaction)
        {
            Success = true;
            Message = message;
            Transaction = transaction;
        }

        public TransactionResult()
        {
            Success = true;
        }


    }
}