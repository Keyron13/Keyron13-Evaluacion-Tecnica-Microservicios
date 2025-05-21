using Microsoft.AspNetCore.Mvc;
using TransactionService.Entities;
using TransactionService.Services;

namespace TransactionService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TransactionsController : ControllerBase
    {
        private readonly ITransactionService _service;

        public TransactionsController(ITransactionService service)
        {
            _service = service;
        }

        // En TransactionsController.cs
        [HttpGet("all")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<Transaction>))]
        public async Task<IActionResult> GetAllTransactions()
        {
            var transactions = await _service.GetAllTransactionsAsync();
            return Ok(transactions);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll(
            [FromQuery] DateTime? startDate,
            [FromQuery] DateTime? endDate,
            [FromQuery] string? type)
        {
            if (type != null && type.ToLower() != "compra" && type.ToLower() != "venta")
                return BadRequest("Tipo de transacción debe ser 'compra' o 'venta'");

            var result = await _service.GetAllAsync(startDate, endDate, type);
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var result = await _service.GetByIdAsync(id);
            return result == null ? NotFound() : Ok(result);
        }

        // En TransactionsController.cs
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Transaction))]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> UpdateTransaction(int id, [FromBody] TransactionUpdateDto dto)
        {
            if (id != dto.Id)
                return BadRequest("ID de transacción no coincide");

            var result = await _service.UpdateTransactionAsync(dto);

            if (!result.Success)
                return BadRequest(result.Message);

            return Ok(result.Transaction);
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Transaction))]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Create([FromBody] TransactionCreateDto dto)
        {
            // Validación básica del DTO
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _service.CreateAsync(dto);

            if (!result.Success)
                return BadRequest(result.Message);

            // Devuelve el objeto Transaction completo con código 201 (Created)
            return CreatedAtAction(
                nameof(GetById),
                new { id = result.Transaction?.Id },
                result.Transaction);
        }

        // En TransactionsController.cs
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> DeleteTransaction(int id)
        {
            var result = await _service.DeleteTransactionAsync(id);

            if (!result.Success)
                return BadRequest(result.Message);

            return NoContent();
        }

    }

    public class TransactionCreateDto
    {
        public string TransactionType { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public string Detail { get; set; }
    }

    // DTO para actualización
    public class TransactionUpdateDto
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string TransactionType { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public string Detail { get; set; }
    }

}