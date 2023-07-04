using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;

namespace OpenGL_1
{
    public class RainDrop
    {
        public static List<RainDrop> All { get; private set; } = new List<RainDrop>();
        public float x, y, z;
        public MediaPlayer soundRain = new MediaPlayer();
        public RainDrop(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
    }
    public class AfterDrop
    {
        public static List<AfterDrop> All { get; private set; } = new List<AfterDrop>();
        public float x, y, z;
        public float size = 0;
        public AfterDrop(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
    }
}
