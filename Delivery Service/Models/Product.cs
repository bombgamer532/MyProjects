using InfoSystem.Controllers;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace InfoSystem.Models
{
    public class Product
    {
        [ForeignKey("History")]
        public Guid Id { get; set; }
        [MaxLength(20)]
        public string Name { get; set; }
        public Guid CategoryId { get; set; }
        public Category Category { get; set; }
        public int Price { get; set; }
        public History? History { get; set; }
    }
}
