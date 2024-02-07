using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.Form1;
using static OpenGL_1.Collision;
using static OpenGL_1.Controls;
using static OpenGL_1.Util;

namespace OpenGL_1
{
    public class Vehicle : Entity
    {
        public static List<Vehicle> All { get; private set; } = new List<Vehicle>();
        public List<Component> vehcomp = new List<Component>();
        public int health = 100;
        public float speed = 0;
        public Ped user;
        public bool damaged = false;
        public List<float[]> path = null;
        public int pathid = -1;
        public int node = -1;
        public int lastnode = -1;
        public Vehicle()
        {
            All.Add(this);
        }
        public void Delete()
        {
            All.Remove(this);
        }
        public void Explode()
        {
            All.Remove(this);
        }

        public static void VehicleControl(object sender, EventArgs e)
        {
            foreach(var v in All)
            {
                if (v.speed > 0.1)
                {
                    if (v.user == player)
                    {
                        if (!HasVehicleCollidedWithAnyObject(v))
                        {
                            if (Key["W"] == false)
                            {
                                v.speed -= 0.01f;
                            }
                        }
                        else
                        {
                            if (v is Boat)
                            {
                                v.speed -= 0.05f;
                            }
                            else
                            {
                                if (Key["W"] == false)
                                {
                                    v.speed -= 0.01f;
                                }
                            }
                        }
                    }
                    else
                    {
                        v.speed -= 0.01f;
                    }
                }
                else if (v.speed < -0.1)
                {
                    if (v.user == player)
                    {
                        if (!HasVehicleCollidedWithAnyObject(v))
                        {
                            if (Key["S"] == false)
                            {
                                v.speed += 0.01f;
                            }
                        }
                        else
                        {
                            if (v is Boat)
                            {
                                v.speed += 0.05f;
                            }
                            else
                            {
                                if (Key["S"] == false)
                                {
                                    v.speed += 0.01f;
                                }
                            }
                        }
                    }
                    else
                    {
                        v.speed += 0.01f;
                    }
                }
                else
                {
                    if (v.user == player)
                    {
                        if (Key["W"] == false && Key["S"] == false)
                        {
                            v.speed = 0;
                        }
                    }
                    else
                    {
                        v.speed = 0;
                    }
                }
                v.x += v.speed * dt * Util.Sin(v.ry);
                v.z += v.speed * dt * Util.Cos(v.ry);
                if (v is Helicopter)
                {
                    if (v.user == player)
                    {
                        if (Key["E"] == true)
                        {
                            v.y += 1f * dt;
                        }
                        if (Key["Q"] == true)
                        {
                            v.y -= 1f * dt;
                        }
                    }
                }
            }
        }

        public static void VehicleBehavior(object sender, EventArgs e)
        {
            foreach (var v in All)
            {
                if (v is Helicopter)
                {
                    if (v.user == null)
                    {
                        v.y -= 1f * dt;
                    }
                }
                else
                {
                    v.y -= 2;
                }
                foreach (var w in Water.All)
                {
                    if (!(v is Boat))
                    {
                        if ((v.x > (w.x - w.sx / 2)) && (v.x < (w.x + w.sx / 2)))
                        {
                            if ((v.z > (w.z - w.sz / 2)) && (v.z < (w.z + w.sz / 2)))
                            {
                                if (v.y < w.y - 80)
                                {
                                    v.y = w.y - 80;
                                }
                            }
                        }
                    }
                }
                if (GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z) < 2500)
                {
                    if (GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z) < 2000)
                    {
                        v.collision = true;
                    }
                    else
                    {
                        v.collision = false;
                    }
                    if (v.type != "dead")
                    {
                        if (v.user != null && v.user != player)
                        {
                            List<Point> nodes = new List<Point>();
                            List<int[]> links = new List<int[]>();
                            if (v is Car)
                            {
                                nodes = Car.carnodes;
                                links = Car.links;
                            }
                            else if (v is Boat)
                            {
                                nodes = Boat.boatnodes;
                                links = Boat.links;
                            }
                            if (v.node == -1)
                            {
                                v.node = GetClosestCoordFromCoordsById(new Point(v.x, v.y, v.z), nodes);
                            }
                            else
                            {
                                v.ry = GetHeading(v.x, v.z, nodes[v.node].x, nodes[v.node].z);
                                v.speed = 1;
                                foreach (var ped in Ped.All)
                                {
                                    if (ped != v.user)
                                    {
                                        if (GetDistanceBetweenCoords(v.x + 100 * Sin(v.ry), v.y, v.z + 100 * Cos(v.ry), ped.x, ped.y, ped.z) < 70)
                                        {
                                            v.speed = 0;
                                            break;
                                        }
                                    }
                                }
                                foreach (var c in All)
                                {
                                    if (c != v)
                                    {
                                        if (GetDistanceBetweenCoords(v.x + 150 * Sin(v.ry), v.y, v.z + 150 * Cos(v.ry), c.x, c.y, c.z) < 100)
                                        {
                                            v.speed = 0;
                                            break;
                                        }
                                    }
                                }
                                if (v.speed > 0)
                                {
                                    v.x += v.speed * dt * Sin(v.ry);
                                    v.z += v.speed * dt * Cos(v.ry);
                                    if (GetDistanceBetweenCoords(v.x, v.y, v.z, nodes[v.node].x, nodes[v.node].y, nodes[v.node].z) < 20)
                                    {
                                        if (links[v.node].Length > 1)
                                        {
                                            Random rnd = new Random();
                                            int r = rnd.Next(0, links[v.node].Length);
                                            while (links[v.node][r] == v.lastnode)
                                            {
                                                r = rnd.Next(0, links[v.node].Length);
                                            }
                                            v.lastnode = v.node;
                                            v.node = links[v.lastnode][r];
                                        }
                                        else
                                        {
                                            v.lastnode = v.node;
                                            v.node = links[v.lastnode][0];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (v.type == "dead")
                {
                    if (framecount % 1000 == 0)
                    {
                        All.Remove(v);
                        v.Delete();
                        break;
                    }
                }
            }
        }
    }
}
