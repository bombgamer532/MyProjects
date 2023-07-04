using Microsoft.AspNetCore.Mvc.Rendering;

namespace InfoSystem.Models
{
    public class TableModel
    {
        public string Table { get; set; }
        public string Column { get; set; }
        public string Value { get; set; }
        public string SelectedValue { get; set; }
        public List<SelectListItem> Options { get; set; }
        public dynamic Data { get; set; }
    }
}
