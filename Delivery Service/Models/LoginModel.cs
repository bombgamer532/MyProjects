using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace InfoSystem.Models
{
	public class LoginModel
	{
		[Required(ErrorMessage = "Це поле обов'язкове")]
		public string Login { get; set; }
		[Required(ErrorMessage = "Це поле обов'язкове")]
		[PasswordPropertyText(true)]
		public string Password { get; set; }
	}
}
