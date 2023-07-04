using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms.VisualStyles;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;
using static OpenGL_1.Ped;

namespace OpenGL_1
{
    public static class PedGenerator
    {
        public static List<Ped> peds = new List<Ped>();
        public static void GeneratePeds(object sender, EventArgs e)
        {
            if (framecount % 10 == 0)
            {
                if (peds.Count < 10)
                {
                    Random rnd = new Random();
                    int r = rnd.Next(0, pednodes.Count);
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, pednodes[r].x, pednodes[r].y, pednodes[r].z) < 2000)
                    {
                        peds.Add(new Ped("regular", pednodes[r].x, pednodes[r].y, pednodes[r].z, 0));
                    }
                }
            }
            if (framecount % 500 == 0)
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
            }
            //var gens = All;
            //for (int i = 0; i < gens.Count; i++)
            //{
            //    for (int j = 0; j < gens[i].num; j++)
            //    {
            //        if (framecount % (500 * (j + 1)) == 0)
            //        {
            //            void Create()
            //            {
            //                Random rnd = new Random();
            //                int r = rnd.Next(0, gens[i].path.Count);
            //                if (GetDistanceBetweenCoords(player.x, player.y, player.z, gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2]) < 2000)
            //                {
            //                    gens[i].peds[j] = new Ped("regular", gens[i].path[r][0], gens[i].path[r][1], gens[i].path[r][2], 0);
            //                    gens[i].peds[j].path = gens[i].path;
            //                    if (r + 1 < gens[i].path.Count)
            //                    {
            //                        gens[i].peds[j].pathid = r + 1;
            //                    }
            //                    else
            //                    {
            //                        gens[i].peds[j].pathid = 0;
            //                    }
            //                }
            //            }
            //            if (gens[i].peds[j] == null)
            //            {
            //                Create();
            //                break;
            //            }
            //            else if (gens[i].peds[j].type == "dead")
            //            {
            //                gens[i].peds[j].Delete();
            //                gens[i].peds[j] = null;
            //                Create();
            //                break;
            //            }
            //            else
            //            {
            //                if (GetDistanceBetweenCoords(player.x, player.y, player.z, gens[i].peds[j].x, gens[i].peds[j].y, gens[i].peds[j].z) > 2500)
            //                {
            //                    gens[i].peds[j].Delete();
            //                    gens[i].peds[j] = null;
            //                    Create();
            //                    break;
            //                }
            //            }
            //        }
            //    }
            //}
        }
    }
}
