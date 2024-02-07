using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;
using static OpenGL_1.Car;

namespace OpenGL_1
{
    public static class CarGenerator
    {
        public static List<Car> cars = new List<Car>();
        public static List<Ped> peds = new List<Ped>();
        public static void GenerateCars(object sender, EventArgs e)
        {
            if (framecount % 10 == 0)
            {
                if (cars.Count < 10)
                {
                    Random rnd = new Random();
                    int r = rnd.Next(0, carnodes.Count);
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, carnodes[r].x, carnodes[r].y, carnodes[r].z) < 2000)
                    {
                        cars.Add(new Car(carnodes[r].x, carnodes[r].y, carnodes[r].z, 0));
                        peds.Add(new Ped("regular", carnodes[r].x, carnodes[r].y, carnodes[r].z, 0));
                        peds.Last().WarpIntoVehicle(cars.Last());
                    }
                }
            }
            if (framecount % 500 == 0)
            {
                foreach (var c in cars)
                {
                    if ((GetDistanceBetweenCoords(player.x, player.y, player.z, c.x, c.y, c.z) < 2500) || (c.type == "dead"))
                    {
                        cars.Remove(c);
                        c.Delete();
                        break;
                    }
                }
            }
        }
    }
}
