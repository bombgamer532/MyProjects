using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;
using static OpenGL_1.Form1;

namespace OpenGL_1
{
    public static class DayNight
    {
        public static int time = 12; 
        public static void DayNightCycle(object sender, EventArgs e)
        {
            if (framecount % 100 == 0)
            {
                time++;
                if (time >= 24)
                {
                    time = 0;
                }
                if ((time >= 19 && time <= 23) || (time >= 0 && time <= 6))
                {
                    if (Lamp.light == false)
                    {
                        for (int i = 0; i < Lamp.All.Count; i++)
                        {
                            Lamp.All[i].lampcomp[4] = new Component("cone", 0, 0, 52, -90, 0, 0, 100, 100, 230, 255, 255, 255, 100);
                        }
                        Lamp.light = true;
                    }
                    else
                    {
                        for (int i = 0; i < Lamp.All.Count; i++)
                        {
                            if (Lamp.All[i].collision == false)
                            {
                                Lamp.All[i].lampcomp[4] = new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                            }
                            else
                            {
                                Lamp.All[i].lampcomp[4] = new Component("cone", 0, 0, 52, -90, 0, 0, 100, 100, 230, 255, 255, 255, 100);
                            }
                        }
                    }
                }
                else
                {
                    if (Lamp.light == true)
                    {
                        for (int i = 0; i < Lamp.All.Count; i++)
                        {
                            Lamp.All[i].lampcomp[4] = new Component("cone", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                        }
                        Lamp.light = false;
                    }
                }
            }
        }
    }
}
