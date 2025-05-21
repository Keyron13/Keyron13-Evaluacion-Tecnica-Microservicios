using Microsoft.AspNetCore.Mvc;
using ProductService.Entities;
using ProductService.Services;

namespace ProductService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductService _service;

        public ProductsController(IProductService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] string? category)
        {
            var products = await _service.GetAllAsync(category);
            return Ok(products);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var product = await _service.GetByIdAsync(id);
            return product == null ? NotFound() : Ok(product);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Product product)
        {
            var created = await _service.CreateAsync(product);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Product product)
        {
            if (id != product.Id) return BadRequest();
            var updated = await _service.UpdateAsync(product);
            return updated == null ? NotFound() : Ok(updated);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var success = await _service.DeleteAsync(id);
            return success ? NoContent() : NotFound();
        }

        [HttpPatch("{id}/stock")]
        public async Task<IActionResult> UpdateStock(int id, [FromBody] StockUpdateDto dto)
        {
            var product = await _service.GetByIdAsync(id);
            if (product == null) return NotFound();

            product.Stock += dto.Quantity;
            if (dto.NewPrice.HasValue)
            {
                product.Price = dto.NewPrice.Value;
            }

            var updated = await _service.UpdateAsync(product);
            return Ok(updated);
        }

    }

    public class StockUpdateDto
    {
        public int Quantity { get; set; }
        public decimal? NewPrice { get; set; }
    }

}

