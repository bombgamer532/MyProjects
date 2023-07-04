namespace InfoSystem.Models
{
    public class ChartModel
    {
        public List<object> xValues { get; set; }
        public List<object> yValues { get; set; }
        public ChartModel()
        {
            xValues = new List<object>();
            yValues = new List<object>();
        }
    }
}
