using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;

namespace OpenGL_1
{
    internal class BoatGenerator
    {
        public static List<BoatGenerator> All { get; private set; } = new List<BoatGenerator>();
        public List<float[]> path;
        public int num;
        public Boat[] boats;
        public BoatGenerator(List<float[]> path, int num)
        {
            boats = new Boat[num];
            this.path = path;
            this.num = num;
            All.Add(this);
        }
        public static void GenerateBoats(object sender, EventArgs e)
        {
            var gens = All;
            for (int i = 0; i < gens.Count; i++)
            {
                for (int j = 0; j < gens[i].num; j++)
                {
                    if (framecount % (500 * (j + 1)) == 0)
                    {
                        if (gens[i].boats.ElementAtOrDefault(j) == null)
                        {
                            Random rnd = new Random();
                            int r = rnd.Next(0, gens[i].path.Count);
                            if (GetDistanceBetweenCoords(player.x, player.y, player.z, gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2]) < 2000)
                            {
                                gens[i].boats[j] = new Boat(gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2], 0);
                                var tempped = new Ped("regular", gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2], 0);
                                tempped.WarpIntoVehicle(gens[i].boats[j]);
                                gens[i].boats[j].path = gens[i].path;
                                if (r + 1 < gens[i].path.Count)
                                {
                                    gens[i].boats[j].pathid = r + 1;
                                }
                                else
                                {
                                    gens[i].boats[j].pathid = 0;
                                }
                            }
                        }
                        else if (gens[i].boats[j].type == "dead")
                        {
                            gens[i].boats[j].Delete();
                            gens[i].boats[j] = null;
                        }
                        else
                        {
                            if (GetDistanceBetweenCoords(player.x, player.y, player.z, gens[i].boats[j].x, gens[i].boats[j].y, gens[i].boats[j].z) > 2500)
                            {
                                gens[i].boats[j].Delete();
                                gens[i].boats[j] = null;
                            }
                        }
                    }
                }
            }
        }
    }
}
