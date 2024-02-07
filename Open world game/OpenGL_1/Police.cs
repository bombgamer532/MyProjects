using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.Form1;
using static OpenGL_1.Ped;
using static OpenGL_1.Car;
using static OpenGL_1.Util;
using static OpenGL_1.Player;

namespace OpenGL_1
{
    public static class Police
    {
        static List<Ped> peds = new List<Ped>();
        static List<Car> cars = new List<Car>();
        public static void PoliceBehavior(object sender, EventArgs e)
        {
            if (wanted > 3)
            {
                wanted = 3;
            }
            if (framecount % 1000 * wanted == 0)
            {
                if (wanted > 0)
                {
                    wanted--;
                }
            }
            if (wanted > 0)
            {
                switch (wanted)
                {
                    case 1:
                        if (framecount % 300 == 0)
                        {
                            if (peds.Count < 3)
                            {
                                Random rnd = new Random();
                                int r = rnd.Next(0, pednodes.Count);
                                if (GetDistanceBetweenCoords(player.x, player.y, player.z, pednodes[r].x, pednodes[r].y, pednodes[r].z) < 2000)
                                {
                                    peds.Add(new Ped("enemy", pednodes[r].x, pednodes[r].y, pednodes[r].z, 0));
                                    peds.Last().pedcomp[0] = new Component("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[1] = new Component("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[2] = new Component("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, 0, 0, 0);
                                    peds.Last().pedcomp[3] = new Component("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, 0, 0, 0);
                                }
                            }
                        }
                        break;
                    case 2:
                        if (framecount % 100 == 0)
                        {
                            if (peds.Count < 5)
                            {
                                Random rnd = new Random();
                                int r = rnd.Next(0, pednodes.Count);
                                if (GetDistanceBetweenCoords(player.x, player.y, player.z, pednodes[r].x, pednodes[r].y, pednodes[r].z) < 2000)
                                {
                                    peds.Add(new Ped("enemy", pednodes[r].x, pednodes[r].y, pednodes[r].z, 0));
                                    peds.Last().pedcomp[0] = new Component("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[1] = new Component("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[2] = new Component("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, 0, 0, 0);
                                    peds.Last().pedcomp[3] = new Component("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, 0, 0, 0);
                                }
                            }
                        }
                        break;
                    case 3:
                        if (framecount % 100 == 0)
                        {
                            if (peds.Count < 10)
                            {
                                Random rnd = new Random();
                                int r = rnd.Next(0, pednodes.Count);
                                if (GetDistanceBetweenCoords(player.x, player.y, player.z, pednodes[r].x, pednodes[r].y, pednodes[r].z) < 2000)
                                {
                                    peds.Add(new Ped("enemy", pednodes[r].x, pednodes[r].y, pednodes[r].z, 0));
                                    peds.Last().pedcomp[0] = new Component("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[1] = new Component("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[2] = new Component("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, 0, 0, 0);
                                    peds.Last().pedcomp[3] = new Component("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, 0, 0, 0);
                                }
                            }
                            if (cars.Count < 3)
                            {
                                Random rnd = new Random();
                                int r = rnd.Next(0, carnodes.Count);
                                if (GetDistanceBetweenCoords(player.x, player.y, player.z, carnodes[r].x, carnodes[r].y, carnodes[r].z) < 2000)
                                {
                                    cars.Add(new Car(carnodes[r].x, carnodes[r].y, carnodes[r].z, 0));
                                    cars.Last().vehcomp[4] = new Component("cube", 0, 30, 0, 0, 0, 0, 90, 30, 200, 0, 0, 0);
                                    cars.Last().vehcomp[7] = new Component("cube", 0, 60, 0, 0, 0, 0, 90, 30, 55, 0, 0, 0);
                                    peds.Add(new Ped("enemy", carnodes[r].x, carnodes[r].y, carnodes[r].z, 0));
                                    peds.Last().pedcomp[0] = new Component("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[1] = new Component("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, 0, 0, 0);
                                    peds.Last().pedcomp[2] = new Component("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, 0, 0, 0);
                                    peds.Last().pedcomp[3] = new Component("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, 0, 0, 0);
                                    peds.Last().WarpIntoVehicle(cars.Last());
                                }
                            }
                        }
                        break;
                }
            }
            if (framecount % 100 == 0)
            {
                for (int i = 0; i < peds.Count; i++)
                {
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, peds[i].x, peds[i].y, peds[i].z) < 2500)
                    {
                        if (peds[i].type == "dead")
                        {
                            peds[i].Delete();
                            peds.RemoveAt(i);
                            break;
                        }
                    }
                    else
                    {
                        peds[i].Delete();
                        peds.RemoveAt(i);
                        break;
                    }
                }
                for (int i = 0; i < cars.Count; i++)
                {
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, cars[i].x, cars[i].y, cars[i].z) < 5000)
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
        }
    }
}
