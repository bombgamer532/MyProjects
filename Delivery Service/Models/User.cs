using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace InfoSystem.Models
{
    public class User
    {
		//[ForeignKey("History")]
		public Guid Id { get; set; }
        public string Login { get; set; }
        [MaxLength(30)]
        public string Password { get; set; }
        public string Phone { get; set; }
		public History? History { get; set; }
	}
}
