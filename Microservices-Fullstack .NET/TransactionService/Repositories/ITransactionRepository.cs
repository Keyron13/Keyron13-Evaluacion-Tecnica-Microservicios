using TransactionService.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace TransactionService.Repositories
{
    public interface ITransactionRepository
    {
        Task<IEnumerable<Transaction>> GetAllAsync(DateTime? startDate, DateTime? endDate, string? type);
        Task<IEnumerable<Transaction>> GetAllTransactionsAsync();
        Task<Transaction?> GetByIdAsync(int id);
        Task<Transaction> CreateAsync(Transaction transaction);
        Task<Transaction> UpdateAsync(Transaction transaction);
        Task<bool> DeleteAsync(int id);
    }
}
