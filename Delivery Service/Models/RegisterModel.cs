using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace InfoSystem.Models
{
	public class RegisterModel
	{
		[Required(ErrorMessage = "Це поле обов'язкове")]
		[MinLength(4, ErrorMessage = "Логін повинен складатися мінімум з 4 символів")]
		public string Login { get; set; }
		[Required(ErrorMessage = "Це поле обов'язкове")]
		[MinLength(6, ErrorMessage = "Пароль поминен складатися мінімум з 6 символів")]
		[PasswordPropertyText(true)]
		[Compare("PasswordRepeat", ErrorMessage = "Пароль не співпадає")]
		public string Password { get; set; }
		[Required(ErrorMessage = "Це поле обов'язкове")]
		[PasswordPropertyText(true)]
		public string PasswordRepeat { get; set; }
		[Required(ErrorMessage = "Це поле обов'язкове")]
		[Phone(ErrorMessage = "Телефон не відповідає формату")]
		public string Phone { get; set; }
	}
}
