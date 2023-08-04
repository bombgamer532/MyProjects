using System.ComponentModel.DataAnnotations;

namespace Task4.Models
{
    public class AuthorModel
    {
        [Required(ErrorMessage = "Це поле обов'язкове")]
        public string Surname { get; set; }
        [Required(ErrorMessage = "Це поле обов'язкове")]
        public string Name { get; set; }
        public string Patronymic { get; set; }
        [Required(ErrorMessage = "Це поле обов'язкове")]
        public DateTime DateOfBirth { get; set; }
    }
}
