using System.ComponentModel.DataAnnotations;

namespace Task4.Models
{
    public class BookModel
    {
        [Required(ErrorMessage = "Це поле обов'язкове")]
        public string Title { get; set; }
        [Required(ErrorMessage = "Це поле обов'язкове")]
        public int Pages { get; set; }
        [Required(ErrorMessage = "Це поле обов'язкове")]
        public string Genre { get; set; }
    }
}
