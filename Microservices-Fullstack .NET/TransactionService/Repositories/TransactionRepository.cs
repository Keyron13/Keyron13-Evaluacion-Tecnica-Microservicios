using Microsoft.EntityFrameworkCore;
using TransactionService.Data;
using TransactionService.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;
using System;

namespace TransactionService.Repositories
{
    public class TransactionRepository : ITransactionRepository
    {
        private readonly TransactionDbContext _context;

        public TransactionRepository(TransactionDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Transaction>> GetAllAsync(DateTime? startDate, DateTime? endDate, string? type)
        {
            var query = _context.Transactions.AsQueryable();

            if (startDate.HasValue)
                query = query.Where(t => t.Date >= startDate.Value);

            if (endDate.HasValue)
                query = query.Where(t => t.Date <= endDate.Value);

            if (!string.IsNullOrEmpty(type))
                query = query.Where(t => t.TransactionType.ToLower() == type.ToLower());

            return await query.ToListAsync();
        }

        public async Task<IEnumerable<Transaction>> GetAllTransactionsAsync()
        {
            return await _context.Transactions
                .OrderByDescending(t => t.Date)
                .ToListAsync();
        }

        public async Task<Transaction?> GetByIdAsync(int id)
        {
            return await _context.Transactions.FindAsync(id);
        }

        public async Task<Transaction> CreateAsync(Transaction transaction)
        {
            _context.Transactions.Add(transaction);
            await _context.SaveChangesAsync();
            return transaction;
        }

        public async Task<Transaction> UpdateAsync(Transaction transaction)
        {
            var existing = await _context.Transactions.FindAsync(transaction.Id);
            if (existing == null)
                throw new KeyNotFoundException($"Transacción con ID {transaction.Id} no encontrada");

            _context.Entry(existing).CurrentValues.SetValues(transaction);
            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var transaction = await _context.Transactions.FindAsync(id);
            if (transaction == null)
                return false;

            _context.Transactions.Remove(transaction);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}