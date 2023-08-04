using System.ComponentModel.DataAnnotations;

namespace Task4.Models
{
    public class Book
    {
        public Guid Id { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        public int Pages { get; set; }
        [Required]
        public string Genre { get; set; }
        public Guid AuthorId { get; set; }
        public Author Author { get; set; }
    }
}
