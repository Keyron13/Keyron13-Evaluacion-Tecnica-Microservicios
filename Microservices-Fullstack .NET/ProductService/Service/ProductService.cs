using ProductService.Entities;
using ProductService.Repositories;

namespace ProductService.Services
{
    public class ProductService : IProductService
    {
        private readonly IProductRepository _repository;

        public ProductService(IProductRepository repository)
        {
            _repository = repository;
        }

        public Task<IEnumerable<Product>> GetAllAsync(string? category = null) =>
            _repository.GetAllAsync(category);

        public Task<Product?> GetByIdAsync(int id) =>
            _repository.GetByIdAsync(id);

        public Task<Product> CreateAsync(Product product) =>
            _repository.CreateAsync(product);

        public Task<Product?> UpdateAsync(Product product) =>
            _repository.UpdateAsync(product);

        public Task<bool> DeleteAsync(int id) =>
            _repository.DeleteAsync(id);
    }
}

