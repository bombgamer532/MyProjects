using System.ComponentModel.DataAnnotations;

namespace Task4.Models
{
    public class Author
    {
        public Guid Id { get; set; }
        [Required]
        public string Surname { get; set; }
        [Required]
        public string Name { get; set; }
        public string Patronymic { get; set; }
        public DateTime DateOfBirth { get; set; }
        public ICollection<Book> Books { get; set; }
    }
}
