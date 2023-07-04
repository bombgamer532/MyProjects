using NetTopologySuite.Geometries;

namespace InfoSystem.Models
{
    public class Location
    {
        public Guid Id { get; set; }
        public string Address { get; set; }
        public Point Loc { get; set; }
    }
}
