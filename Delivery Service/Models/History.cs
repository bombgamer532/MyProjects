﻿namespace InfoSystem.Models
{
    public class History
    {
        public Guid Id { get; set; }
        public Guid ProductId { get; set; }
        public Product? Product { get; set; }
        public Guid UserId { get; set; }
        public User? User { get; set; }
        public DateTime Date { get; set; }
    }
}
