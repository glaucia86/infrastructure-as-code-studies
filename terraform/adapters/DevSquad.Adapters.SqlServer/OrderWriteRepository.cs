using DevSquad.Modules.Application.Abstractions.Commands;
using DevSquad.Modules.Domain.Enums;

namespace DevSquad.Adapters.SqlServer
{
    public class OrderWriteRepository : IOrderWriteRepository
    {
        public string PlaceOrder(Customer customer, Order order)
        {
            const string characters = "0123456789" +
                                                  "abcdefghijklmnopqrstuvwxyz" +
                                                  "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            var random = new Random();
            return new string(Enumerable.Repeat(characters, 10).Select(s => s[random.Next(s.Length)]).ToArray());
        }
    }
}
