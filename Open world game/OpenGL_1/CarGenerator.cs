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
                for (int i = 0; i < cars.Count; i++)
                {
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, cars[i].x, cars[i].y, cars[i].z) < 2500)
                    {
                        if (cars[i].type == "dead")
                        {
                            cars[i].Delete();
                            cars.RemoveAt(i);
                            break;
                        }
                    }
                    else
                    {
                        cars[i].Delete();
                        cars.RemoveAt(i);
                        break;
                    }
                }
            }
            //var gens = All;
            //for (int i = 0; i < gens.Count; i++)
            //{
            //    for (int j = 0; j < gens[i].num; j++)
            //    {
            //        if (framecount % (500 * (j + 1)) == 0)
            //        {
            //            if (gens[i].cars.ElementAtOrDefault(j) == null)
            //            {
            //                Random rnd = new Random();
            //                int r = rnd.Next(0, gens[i].path.Count);
            //                if (GetDistanceBetweenCoords(player.x, player.y, player.z, gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2]) < 2000)
            //                {
            //                    gens[i].cars[j] = new Car(gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2], 0);
            //                    var tempped = new Ped("regular", gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2], 0);
            //                    tempped.WarpIntoVehicle(gens[i].cars[j]);
            //                    gens[i].cars[j].path = gens[i].path;
            //                    if (r + 1 < gens[i].path.Count)
            //                    {
            //                        gens[i].cars[j].pathid = r + 1;
            //                    }
            //                    else
            //                    {
            //                        gens[i].cars[j].pathid = 0;
            //                    }
            //                }
            //            }
            //            else if (gens[i].cars[j].type == "dead")
            //            {
            //                gens[i].cars[j].Delete();
            //                gens[i].cars[j] = null;
            //            }
            //            else
            //            {
            //                if (GetDistanceBetweenCoords(player.x, player.y, player.z, gens[i].cars[j].x, gens[i].cars[j].y, gens[i].cars[j].z) > 2500)
            //                {
            //                    gens[i].cars[j].Delete();
            //                    gens[i].cars[j] = null;
            //                }
            //            }
            //        }
            //    }
            //}
        }
    }
}
