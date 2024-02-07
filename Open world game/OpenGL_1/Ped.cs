using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using Tao.Platform.Windows;
using static OpenGL_1.Util;
using static OpenGL_1.v;
using static OpenGL_1.Form1;
using Tao.FreeGlut;

namespace OpenGL_1
{
	public class Ped : Entity
	{
        public static List<Ped> All { get; private set; } = new List<Ped>();
        public List<Component> pedcomp = new List<Component>();
		public float health = 100;
        public int weapon = 0;
        public Dictionary<int, int> ammo = new Dictionary<int, int>();
		public List<Trail> trail = new List<Trail>();
		public int footstep = 0;
		public int blood = 0;
		public bool damaged = false;
		public Vehicle vehicle = null;
		public MediaPlayer soundStep = new MediaPlayer();
		public MediaPlayer soundShot = new MediaPlayer();
		public List<float[]> path = null;
		public int pathid = -1;
		public int prevpathid = -1;
		List<float[]> pathpoints = new List<float[]>();
		int pathstate = 0;
		public int state = 0;
		public bool visible = true;
		//public List<float[]> pednodes = new List<float[]>();
		List<float[]> carnodes = new List<float[]>();
		List<float[]> boatnodes = new List<float[]>();
		public Ped() { }
		public Ped(string type, float x, float y, float z, float ry)
		{
			Random rnd = new Random();
			byte[] color1 = new byte[] { (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256) };
			byte[] color2 = new byte[] { (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256), (byte)rnd.Next(0, 256) };
			pedcomp.Add(new Component("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, color1[0], color1[1], color1[2]));
			pedcomp.Add(new Component("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, color1[0], color1[1], color1[2]));
			pedcomp.Add(new Component("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, color2[0], color2[1], color2[2]));
			pedcomp.Add(new Component("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, color2[0], color2[1], color2[2]));
			pedcomp.Add(new Component("cube", 25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new Component("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new Component("sphere", 0, 100, 0, 0, 0, 0, 10, 10, 10, 255, 255, 150));
			pedcomp.Add(new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
			pedcomp.Add(new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
            pedcomp.Add(new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));

            ammo.Add(0, 0);

            this.type = type;
			this.x = x;
			this.y = y;
			this.z = z;
			this.ry = ry;
			All.Add(this);
		}
		public void Delete()
		{
			All.Remove(this);
		}
		public void AttackPlayer()
		{
			if (type != "dead")
			{
				type = "enemy";
			}
		}
		public bool IsInVehicle(Vehicle veh)
		{
			return veh.user == this;
		}
		public bool IsInAnyVehicle()
		{
			return vehicle != null;
		}
		public void WarpIntoVehicle(Vehicle veh)
		{
			x = veh.x;
			y = veh.y;
			z = veh.z;
			ry = veh.ry;
			veh.user = this;
			vehicle = veh;
			visible = false;
		}
		public void LeaveVehicle()
		{
			if (vehicle != null)
			{
				x += 70 * Sin(vehicle.ry + 90);
				y = vehicle.y;
				z += 70 * Cos(vehicle.ry + 90);
				ry = vehicle.ry;
				vehicle.user = null;
				vehicle = null;
				visible = true;
			}
		}
		public void SetPath(List<float[]> path)
		{
			this.path = path;
		}
        public void FindPath()
        {
            node = GetClosestCoordFromCoordsById(new Point(x, y, z), pednodes);
        }

        public static List<Point> pednodes = new List<Point>()
        {
            new Point(1570, 100, 6430),
            new Point(1562, 100, 1585),
            new Point(6421, 100, 1617),
            new Point(6432, 100, 933),
            new Point(6434, 100, -1408),
            new Point(6435, 100, -2072),
            new Point(6432, 100, -6422),
            new Point(1574, 100, -6429),
            new Point(-1413, 100, -6439),
            new Point(-2059, 100, -6435),
            new Point(-3913, 100, -6433),

            new Point(1561, 100, 933),
            new Point(1566, 100, -1416),
            new Point(1533, 100, -2067),
            new Point(1475, 100, -2934),
            new Point(5545, 100, -2938),
            new Point(5550, 100, -5550),
            new Point(1561, 100, -5557),
            new Point(1559, 100, -4941),
            new Point(1570, 100, -3574),
            new Point(4912, 100, -3581),
            new Point(4944, 100, -4938),

            new Point(6448, 100, 6433),
            new Point(938, 100, 1563),
            new Point(-3430, 100, 1563),
            new Point(-3429, 100, 6422),
            new Point(913, 100, 6431),

            new Point(953, 100, 957),
            new Point(536, 100, 961),
            new Point(535, 100, -1444),
            new Point(-62, 100, -1444),
            new Point(-2938, 100, -1436),
            new Point(-64, 100, 940),
            new Point(-2945, 100, 1561),

            new Point(536, 100, -2073),
            new Point(-2946, 100, -2072),

            new Point(549, 100, -2948),
            new Point(547, 100, -5547),
            new Point(-1440, 100, -5549),
            new Point(-2046, 100, -5548),
            new Point(-3541, 100, -5550),
            new Point(-3550, 100, -3540),
            new Point(-2938, 100, -3562),
            new Point(-56, 100, -3561),
            new Point(-61, 100, -4941),
            new Point(-2931, 100, -4935),

            new Point(-2923, 100, 933)
        };
        public static List<int[]> links = new List<int[]>()
        {
            new int[] {1,22},
            new int[] {2,0,11},
            new int[] {3,1,22},
            new int[] {4,2,11},
            new int[] {5,3},
            new int[] {6,4},
            new int[] {7,5},
            new int[] {8,6,17},
            new int[] {9,7,38},
            new int[] {10,8,39},
            new int[] {9},

            new int[] {12,1,3,27},
            new int[] {11,4,13},
            new int[] {12,5,14,34},
            new int[] {13,15,19},
            new int[] {16,14},
            new int[] {17,15},
            new int[] {18,16,7},
            new int[] {19,17,21},
            new int[] {20,18,14},
            new int[] {21,19},
            new int[] {18,20},
            
            new int[] {2,0},
            new int[] {24,1,26},
            new int[] {25,23,33},
            new int[] {26,24},
            new int[] {0,25,23},

            new int[] {28,11,23},
            new int[] {29,27,32},
            new int[] {30,28,34},
            new int[] {31,29,32},
            new int[] {32,30,33},
            new int[] {46,28,30},
            new int[] {31,24,23},

            new int[] {35,29,13,36},
            new int[] {31,34},

            new int[] {37,34},
            new int[] {38,36},
            new int[] {39,37,8},
            new int[] {40,38,9},
            new int[] {41,39},
            new int[] {42,40},
            new int[] {43,41},
            new int[] {44,42},
            new int[] {45,43},
            new int[] {42,44},

            new int[] {31,32,33}
        };
        public int node = -1;
        public int lastnode = -1;
        public static void Test(object sender, EventArgs e)
        {
            for (int i = 0; i < pednodes.Count; i++)
            {
                DrawTextAtCoord(Glut.GLUT_BITMAP_HELVETICA_18, "" + i, pednodes[i].x, pednodes[i].y, pednodes[i].z, 0, 0, 0);
            }
        }

        public static void PedBehavior(object sender, EventArgs e)
		{
            var peds = All;
            var vehs = Vehicle.All;
            var objs = Object.All;
            foreach (var p in Ped.All)
            {
                if (p != player)
                {
                    p.y -= 2;
                }
                foreach (var w in Water.All)
                {
                    if ((p.x > (w.x - w.sx / 2)) && (p.x < (w.x + w.sx / 2)))
                    {
                        if ((p.z > (w.z - w.sz / 2)) && (p.z < (w.z + w.sz / 2)))
                        {
                            if (p.y < w.y - 80)
                            {
                                p.y = w.y - 80;
                            }
                        }
                    }
                }
                if (p.visible == true)
                {
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y, p.z) < 2500)
                    {
                        if (GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y, p.z) < 2000)
                        {
                            p.collision = true;
                        }
                        else
                        {
                            p.collision = false;
                        }
                        if (p.type == "regular" || p.type == "neutral+regular")
                        {
                            if (p.node == -1)
                            {
                                p.node = GetClosestCoordFromCoordsById(new Point(p.x, p.y, p.z), pednodes);
                            }
                            p.ry = GetHeading(p.x, p.z, pednodes[p.node].x, pednodes[p.node].z);
                            if (p.state == 0)
                            {
                                p.x += 1 * dt * Sin(p.ry);
                                p.z += 1 * dt * Cos(p.ry);
                            }
                            else if (p.state == 2)
                            {
                                p.x += 2 * dt * Sin(p.ry);
                                p.z += 2 * dt * Cos(p.ry);
                            }
                            if (GetDistanceBetweenCoords(p.x, p.y, p.z, pednodes[p.node].x, pednodes[p.node].y, pednodes[p.node].z) < 10)
                            {
                                if (links[p.node].Length > 1)
                                {
                                    Random rnd = new Random();
                                    int r = rnd.Next(0, links[p.node].Length);
                                    while (links[p.node][r] == p.lastnode)
                                    {
                                        r = rnd.Next(0, links[p.node].Length);
                                    }
                                    p.lastnode = p.node;
                                    p.node = links[p.lastnode][r];
                                }
                                else
                                {
                                    p.lastnode = p.node;
                                    p.node = links[p.lastnode][0];
                                }
                            }
                            if (p.state == 2)
                            {
                                if (framecount % 1000 == 0)
                                {
                                    p.state = 0;
                                }
                            }
                        }
                        else if (p.type == "enemy")
                        {
                            p.pedcomp[5] = new Component("cube", -15, 85, 15, 0, 30, 0, 10, 10, 40, 255, 255, 150);
                            p.pedcomp[7] = new Component("cube", 0, 85, 35, 0, 0, 0, 7, 10, 7, 0, 0, 0);
                            p.pedcomp[8] = new Component("cube", 0, 90, 40, 0, 0, 0, 7, 7, 20, 0, 0, 0);

                            float x = p.x;
                            float y = p.y;
                            float z = p.z;
                            if (GetDistanceBetweenCoords(x, y, z, player.x, player.y, player.z) > 200)
                            {
                                p.ry = GetHeading(x, z, player.x, player.z);
                                p.x = x + 2 * dt * Sin(p.ry);
                                p.z = z + 2 * dt * Cos(p.ry);
                            }
                            else
                            {
                                p.ry = GetHeading(x, z, player.x, player.z);
                                float pitch = GetPitch(x, y + 90, z, player.x, player.y + 45, player.z);
                                if (framecount % 100 == 0)
                                {
                                    float radius = 1000f;
                                    float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y, p.z);
                                    if (dist < radius)
                                    {
                                        var sound = p.soundShot;
                                        sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\PISTOL_SHOT1.wav"));
                                        sound.Play();
                                        sound.Volume = (radius - dist) / radius;
                                    }
                                    for (int i = 0; i < 1000; i++)
                                    {
                                        float desiredX = x + i * Cos(pitch) * Sin(p.ry);
                                        float desiredY = y + 90 + i * Sin(pitch);
                                        float desiredZ = z + i * Cos(pitch) * Cos(p.ry);
                                        foreach (var o in Object.All)
                                        {
                                            var col = ProcessCollision(o.x, o.y, o.z, o.ry, o.sx, o.sy, o.sz, 1, desiredX, desiredY, desiredZ);
                                            if (col.collided == true)
                                            {
                                                if (Player.bulletholes.Count == 10)
                                                {
                                                    Player.bulletholes.RemoveAt(0);
                                                }
                                                Player.bulletholes.Add(new Point(col.dot.x, col.dot.y, col.dot.z));
                                                goto finish;
                                            }
                                        }
                                        foreach (var v in Vehicle.All)
                                        {
                                            if (v.type != "dead")
                                            {
                                                float ox = v.x;
                                                float oy = v.y + 35;
                                                float oz = v.z;
                                                float oh = v.ry;
                                                float osx = 90;
                                                float osy = 70;
                                                float osz = 200;
                                                if (v is Helicopter)
                                                {
                                                    osy = 100;
                                                }
                                                var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 1, desiredX, desiredY, desiredZ);
                                                if (col.collided == true)
                                                {
                                                    v.health -= 10;
                                                    v.damaged = true;
                                                    if (v.health <= 0)
                                                    {
                                                        if (v.user != null)
                                                        {
                                                            v.user.type = "dead";
                                                            v.user.visible = true;
                                                        }
                                                        v.type = "dead";
                                                        new Explosion(ox, oy, oz, 150);
                                                    }
                                                    goto finish;
                                                }
                                            }
                                        }
                                        if (player.visible == true)
                                        {
                                            if (GetDistanceBetweenCoords(desiredX, desiredY, desiredZ, player.x, player.y + 50, player.z) < 50)
                                            {
                                                player.health -= 10;
                                                player.damaged = true;
                                                if (player.health <= 0)
                                                {
                                                    player.x = 0;
                                                    player.y = 100;
                                                    player.z = 0;
                                                    player.rx = 0;
                                                    player.ry = 0;
                                                    player.health = 100;
                                                    mission = 0;
                                                }
                                                goto finish;
                                            }
                                        }
                                    }
                                finish:;
                                }
                            }
                        }
                    }
                }
                else
                {
                    foreach (var v in Vehicle.All)
                    {
                        if (v.type != "dead")
                        {
                            if (v.user == p)
                            {
                                if (p.type == "enemy")
                                {
                                    if (GetDistanceBetweenCoords(v.x, v.y, v.z, player.x, player.y, player.z) > 1000)
                                    {
                                        v.ry = GetHeading(v.x, v.z, player.x, player.z);
                                        v.speed = 2;
                                        v.x += v.speed * dt * Sin(v.ry);
                                        v.z += v.speed * dt * Cos(v.ry);
                                    }
                                    else
                                    {
                                        p.LeaveVehicle();
                                    }
                                }
                                if (GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z) < 2500)
                                {
                                    p.x = v.x;
                                    p.y = v.y;
                                    p.z = v.z;
                                    p.ry = v.ry;
                                }
                            }
                        }
                    }
                }
                if (p.type == "dead")
                {
                    if (framecount % 1000 == 0)
                    {
                        peds.Remove(p);
                        p.Delete();
                        break;
                    }
                }
            }
        }
	}
}
