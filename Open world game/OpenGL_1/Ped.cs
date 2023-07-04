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
        public List<PedComp> pedcomp = new List<PedComp>();
		public float health = 100;
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
			pedcomp.Add(new PedComp("cube", 10, 25, 0, 0, 0, 0, 10, 50, 10, color1[0], color1[1], color1[2]));
			pedcomp.Add(new PedComp("cube", -10, 25, 0, 0, 0, 0, 10, 50, 10, color1[0], color1[1], color1[2]));
			pedcomp.Add(new PedComp("cube", 0, 70, 0, 0, 0, 0, 30, 40, 10, color2[0], color2[1], color2[2]));
			pedcomp.Add(new PedComp("cube", 0, 85, 0, 0, 0, 0, 40, 10, 10, color2[0], color2[1], color2[2]));
			pedcomp.Add(new PedComp("cube", 25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new PedComp("cube", -25, 70, 0, 0, 0, 0, 10, 40, 10, 255, 255, 150));
			pedcomp.Add(new PedComp("sphere", 0, 100, 0, 0, 0, 0, 10, 10, 10, 255, 255, 150));
			pedcomp.Add(new PedComp("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
			pedcomp.Add(new PedComp("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
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
            new int[] {31,28,30},
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
            for (int j = 0; j < peds.Count; j++)
            {
                if (peds[j] != player)
                {
                    peds[j].y -= 2;
                }
                var water = Water.All;
                for (int i = 0; i <= water.Count - 1; i++)
                {
                    float ox = water[i].x;
                    float oy = water[i].y;
                    float oz = water[i].z;
                    float osx = water[i].sx;
                    float osy = water[i].sy;
                    float osz = water[i].sz;
                    if ((peds[j].x > (ox - osx / 2)) && (peds[j].x < (ox + osx / 2)))
                    {
                        if ((peds[j].z > (oz - osz / 2)) && (peds[j].z < (oz + osz / 2)))
                        {
                            if (peds[j].y < oy - 80)
                            {
                                peds[j].y = oy - 80;
                            }
                        }
                    }
                }
                if (peds[j].visible == true)
                {
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, peds[j].x, peds[j].y, peds[j].z) < 2500)
                    {
                        if (GetDistanceBetweenCoords(player.x, player.y, player.z, peds[j].x, peds[j].y, peds[j].z) < 2000)
                        {
                            peds[j].collision = true;
                        }
                        else
                        {
                            peds[j].collision = false;
                        }
                        if (peds[j].type == "regular" || peds[j].type == "neutral+regular")
                        {
                            if (peds[j].node == -1)
                            {
                                peds[j].node = GetClosestCoordFromCoordsById(new Point(peds[j].x, peds[j].y, peds[j].z), pednodes);
                            }
                            peds[j].ry = GetHeading(peds[j].x, peds[j].z, pednodes[peds[j].node].x, pednodes[peds[j].node].z);
                            if (peds[j].state == 0)
                            {
                                peds[j].x += 1 * dt * Sin(peds[j].ry);
                                peds[j].z += 1 * dt * Cos(peds[j].ry);
                            }
                            else if (peds[j].state == 2)
                            {
                                peds[j].x += 2 * dt * Sin(peds[j].ry);
                                peds[j].z += 2 * dt * Cos(peds[j].ry);
                            }
                            if (GetDistanceBetweenCoords(peds[j].x, peds[j].y, peds[j].z, pednodes[peds[j].node].x, pednodes[peds[j].node].y, pednodes[peds[j].node].z) < 10)
                            {
                                if (links[peds[j].node].Length > 1)
                                {
                                    Random rnd = new Random();
                                    int r = rnd.Next(0, links[peds[j].node].Length);
                                    while (links[peds[j].node][r] == peds[j].lastnode)
                                    {
                                        r = rnd.Next(0, links[peds[j].node].Length);
                                    }
                                    peds[j].lastnode = peds[j].node;
                                    peds[j].node = links[peds[j].lastnode][r];
                                }
                                else
                                {
                                    peds[j].lastnode = peds[j].node;
                                    peds[j].node = links[peds[j].lastnode][0];
                                }
                            }
                            if (peds[j].state == 2)
                            {
                                if (framecount % 1000 == 0)
                                {
                                    peds[j].state = 0;
                                }
                            }
                        }
                        else if (peds[j].type == "enemy")
                        {
                            peds[j].pedcomp[5] = new PedComp("cube", -15, 85, 15, 0, 30, 0, 10, 10, 40, 255, 255, 150);
                            peds[j].pedcomp[7] = new PedComp("cube", 0, 85, 35, 0, 0, 0, 7, 10, 7, 0, 0, 0);
                            peds[j].pedcomp[8] = new PedComp("cube", 0, 90, 40, 0, 0, 0, 7, 7, 20, 0, 0, 0);

                            float x = peds[j].x;
                            float y = peds[j].y;
                            float z = peds[j].z;
                            if (GetDistanceBetweenCoords(x, y, z, player.x, player.y, player.z) > 200)
                            {
                                peds[j].ry = GetHeading(x, z, player.x, player.z);
                                peds[j].x = x + 2 * dt * Sin(peds[j].ry);
                                peds[j].z = z + 2 * dt * Cos(peds[j].ry);
                            }
                            else
                            {
                                peds[j].ry = GetHeading(x, z, player.x, player.z);
                                float pitch = GetPitch(x, y + 90, z, player.x, player.y + 45, player.z);
                                if (framecount % 100 == 0)
                                {
                                    float radius = 1000f;
                                    float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, peds[j].x, peds[j].y, peds[j].z);
                                    if (dist < radius)
                                    {
                                        var sound = peds[j].soundShot;
                                        sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\PISTOL_SHOT1.wav"));
                                        sound.Play();
                                        sound.Volume = (radius - dist) / radius;
                                    }
                                    for (int i = 0; i < 1000; i++)
                                    {
                                        float heading = peds[j].ry;
                                        float desiredX = x + i * Cos(pitch) * Sin(heading);
                                        float desiredY = y + 90 + i * Sin(pitch);
                                        float desiredZ = z + i * Cos(pitch) * Cos(heading);
                                        for (int k = 0; k < objs.Count; k++)
                                        {
                                            float ox = objs[k].x;
                                            float oz = objs[k].y;
                                            float oy = objs[k].z;
                                            float oh = objs[k].ry;
                                            float osx = objs[k].sx;
                                            float osy = objs[k].sy;
                                            float osz = objs[k].sz;
                                            var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 1, desiredX, desiredY, desiredZ);
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
                                        /*for (int k = 0; k < peds.Count; k++)
                                        {
                                            if (k != j)
                                            {
                                                if (peds[k][0].ToString() != "none")
                                                {
                                                    if (peds[k][0].ToString() != "dead")
                                                    {
                                                        if (GetDistanceBetweenCoords(desiredX, desiredY, desiredZ, (float)peds[k][1], (float)peds[k][2] + 50, (float)peds[k][3]) < 50)
                                                        {
                                                            pedhealth[k] -= 10;
                                                            peddamaged[k] = true;
                                                            if (pedhealth[k] <= 0)
                                                            {
                                                                //DeletePed(k);
                                                                peds[k][0] = "dead";
                                                            }
                                                            goto finish;
                                                        }
                                                        if (peds[k][0].ToString() == "regular")
                                                        {
                                                            if (GetDistanceBetweenCoords((float)peds[j][1], (float)peds[j][2], (float)peds[j][3], (float)peds[k][1], (float)peds[k][2] + 50, (float)peds[k][3]) < 500)
                                                            {
                                                                pedstate[k] = 2;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }*/
                                        for (int k = 0; k < vehs.Count; k++)
                                        {
                                            if (vehs[k].type != "dead")
                                            {
                                                float ox = vehs[k].x;
                                                float oy = vehs[k].y + 35;
                                                float oz = vehs[k].z;
                                                float oh = vehs[k].ry;
                                                float osx = 90;
                                                float osy = 70;
                                                float osz = 200;
                                                if (vehs[k] is Helicopter)
                                                {
                                                    osy = 100;
                                                }
                                                var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 1, desiredX, desiredY, desiredZ);
                                                if (col.collided == true)
                                                {
                                                    vehs[k].health -= 10;
                                                    vehs[k].damaged = true;
                                                    if (vehs[k].health <= 0)
                                                    {
                                                        if (vehs[k].user != null)
                                                        {
                                                            vehs[k].user.type = "dead";
                                                            vehs[k].user.visible = true;
                                                        }
                                                        vehs[k].type = "dead";
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
                    for (int i = 0; i < vehs.Count; i++)
                    {
                        if (vehs[i].type != "dead")
                        {
                            if (vehs[i].user == peds[j])
                            {
                                if (peds[j].type == "enemy")
                                {
                                    if (GetDistanceBetweenCoords(vehs[i].x, vehs[i].y, vehs[i].z, player.x, player.y, player.z) > 1000)
                                    {
                                        vehs[i].ry = GetHeading(vehs[i].x, vehs[i].z, player.x, player.z);
                                        vehs[i].speed = 2;
                                        vehs[i].x += vehs[i].speed * dt * Sin(vehs[i].ry);
                                        vehs[i].z += vehs[i].speed * dt * Cos(vehs[i].ry);
                                    }
                                    else
                                    {
                                        peds[j].LeaveVehicle();
                                    }
                                }
                                if (GetDistanceBetweenCoords(player.x, player.y, player.z, vehs[i].x, vehs[i].y, vehs[i].z) < 2500)
                                {
                                    peds[j].x = vehs[i].x;
                                    peds[j].y = vehs[i].y;
                                    peds[j].z = vehs[i].z;
                                    peds[j].ry = vehs[i].ry;
                                }
                            }
                        }
                    }
                }
                if (peds[j].type == "dead")
                {
                    if (framecount % 1000 == 0)
                    {
                        peds[j].Delete();
                        peds.RemoveAt(j);
                        break;
                    }
                }
            }
        }
	}
	public class PedComp
	{
		public string type;
		public float x, y, z;
		public float rx, ry, rz;
		public float sx, sy, sz;
		public byte r, g, b;
		public PedComp(string type, float x, float y, float z, float rx, float ry, float rz, float sx, float sy, float sz, byte r, byte g, byte b)
		{
			this.type = type;
			this.x = x;
			this.y = y;
			this.z = z;
			this.rx = rx;
			this.ry = ry;
			this.rz = rz;
			this.sx = sx;
			this.sy = sy;
			this.sz = sz;
			this.r = r;
			this.g = g;
			this.b = b;
		}
	}
}
