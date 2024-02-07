using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static OpenGL_1.v;
using static OpenGL_1.Form1;
using static OpenGL_1.Util;
using Tao.FreeGlut;

namespace OpenGL_1
{
    public static class Collision
    {
        public static void Collisions(object sender, EventArgs e)
        {
            foreach (var o in Object.All)
            {
                var col = ProcessCollision(o.x, o.y, o.z, o.ry, o.sx, o.sy, o.sz, 20, player.x, player.y, player.z);
                if (col.collided == true)
                {
                    player.jumpblocker = false;
                }
                foreach (var v in Vehicle.All)
                {
                    col = ProcessCollision(o.x, o.y, o.z, o.ry, o.sx, o.sy, o.sz, 100, v.x, v.y, v.z);
                    if (col.collided == true)
                    {
                        if (o.material == 1)
                        {
                            if (v is Car)
                            {
                                if (v.y < col.dot.y)
                                {
                                    int r = o.r;
                                    int g = o.g;
                                    int b = o.b;
                                    r = r - 50;
                                    if (r < 0)
                                    {
                                        r = 0;
                                    }
                                    g = g - 50;
                                    if (g < 0)
                                    {
                                        g = 0;
                                    }
                                    b = b - 50;
                                    if (b < 0)
                                    {
                                        b = 0;
                                    }
                                    float ch = v.ry;
                                    float tempX = 0, tempZ = 0;
                                    for (int k = 1; k <= 4; k++)
                                    {
                                        switch (k)
                                        {
                                            case 1:
                                                tempX = col.dot.x + 60 * Sin(ch) + 40 * Sin(ch - 90);
                                                tempZ = col.dot.z + 60 * Cos(ch) + 40 * Cos(ch - 90); break;
                                            case 2:
                                                tempX = col.dot.x + 60 * Sin(ch) + 40 * Sin(ch + 90);
                                                tempZ = col.dot.z + 60 * Cos(ch) + 40 * Cos(ch + 90); break;
                                            case 3:
                                                tempX = col.dot.x + 60 * Sin(ch - 180) + 40 * Sin(ch - 90);
                                                tempZ = col.dot.z + 60 * Cos(ch - 180) + 40 * Cos(ch - 90); break;
                                            case 4:
                                                tempX = col.dot.x + 60 * Sin(ch - 180) + 40 * Sin(ch + 90);
                                                tempZ = col.dot.z + 60 * Cos(ch - 180) + 40 * Cos(ch + 90); break;
                                        }
                                        var c = GetRotatedPoint(o.x, o.z, tempX, tempZ, o.ry);
                                        if (c.x > o.x - o.sx / 2 && c.x < o.x + o.sx / 2)
                                        {
                                            if (c.y > o.z - o.sz / 2 && c.y < o.z + o.sz / 2)
                                            {
                                                float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z);
                                                if (dist < 200)
                                                {
                                                    //var sound = ((Car)vehs[j]).soundTrail;
                                                    //sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\GRAVEL_SCRAPE_LOW_2.wav"));
                                                    //sound.Play();
                                                    //sound.Volume = ((radius - dist) / radius) / 2f;
                                                }
                                                var veh = (Car)v;
                                                var trail = veh.trail;
                                                if (trail.Count == 200)
                                                {
                                                    trail.RemoveAt(0);
                                                }
                                                trail.Add(new Trail(tempX, col.dot.y + 0.1f, tempZ, ch, (byte)r, (byte)g, (byte)b));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (col.dot.x != v.x || col.dot.z != v.z)
                        {
                            float r = 200f;
                            float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z);
                            if (dist < r)
                            {
                                if (v is Car)
                                {
                                    var sound = ((Car)v).soundCol;
                                    sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\DEFORMATION_LOW_1.wav"));
                                    sound.Play();
                                    sound.Volume = ((r - dist) / r) / 3f;
                                }
                                if (v.speed > 1)
                                {
                                    v.speed -= 0.1f;
                                }
                                else if (v.speed < -1)
                                {
                                    v.speed += 0.1f;
                                }
                            }
                        }
                        v.x = col.dot.x;
                        v.y = col.dot.y;
                        v.z = col.dot.z;
                    }
                }
                foreach (var p in Ped.All)
                {
                    col = ProcessCollision(o.x, o.y, o.z, o.ry, o.sx, o.sy, o.sz, 20, p.x, p.y, p.z);
                    if (col.collided == true)
                    {
                        if (!p.IsInAnyVehicle())
                        {
                            if (o.material == 1)
                            {
                                if (p.y < col.dot.y)
                                {
                                    int r = o.r;
                                    int g = o.g;
                                    int b = o.b;
                                    r = r - 50;
                                    if (r < 0)
                                    {
                                        r = 0;
                                    }
                                    g = g - 50;
                                    if (g < 0)
                                    {
                                        g = 0;
                                    }
                                    b = b - 50;
                                    if (b < 0)
                                    {
                                        b = 0;
                                    }
                                    float ch = p.ry;
                                    float tempX = 0, tempZ = 0;
                                    if (p.footstep == 1)
                                    {
                                        tempX = col.dot.x + 10 * Sin(ch - 90);
                                        tempZ = col.dot.z + 10 * Cos(ch - 90);
                                    }
                                    else
                                    {
                                        tempX = col.dot.x + 10 * Sin(ch + 90);
                                        tempZ = col.dot.z + 10 * Cos(ch + 90);
                                    }
                                    var c = GetRotatedPoint(o.x, o.z, tempX, tempZ, o.ry);
                                    if (c.x > o.x - o.sx / 2 && c.x < o.x + o.sx / 2)
                                    {
                                        if (c.y > o.z - o.sz / 2 && c.y < o.z + o.sz / 2)
                                        {
                                            if (framecount % 10 == 0)
                                            {
                                                float radius = 200f;
                                                float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, p.x, p.y, p.z);
                                                if (dist < 200)
                                                {
                                                    p.soundStep.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\GRASS_3.wav"));
                                                    p.soundStep.Play();
                                                    p.soundStep.Volume = (radius - dist) / radius;
                                                }
                                                if (p.trail.Count == 10)
                                                {
                                                    p.trail.RemoveAt(0);
                                                }
                                                p.trail.Add(new Trail(tempX, col.dot.y + 0.1f, tempZ, ch, (byte)r, (byte)g, (byte)b));
                                                if (p.footstep == 1)
                                                {
                                                    p.footstep = 0;
                                                }
                                                else
                                                {
                                                    p.footstep = 1;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        p.x = col.dot.x;
                        p.y = col.dot.y;
                        p.z = col.dot.z;
                    }
                }
            }
            foreach (var v in Vehicle.All)
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
                    oy = v.y + 50;
                    osy = 100;
                }
                float radius = 20;
                var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, player.x, player.y, player.z);
                if (col.collided == true)
                {
                    player.x = col.dot.x;
                    player.y = col.dot.y;
                    player.z = col.dot.z;
                    player.jumpblocker = false;
                }
                if (v is Boat)
                {
                    foreach (var w in Water.All)
                    {
                        if ((v.x > (w.x - w.sx / 2)) && (v.x < (w.x + w.sx / 2)))
                        {
                            if ((v.z > (w.z - w.sz / 2)) && (v.z < (w.z + w.sz / 2)))
                            {
                                if (v.y < w.y - 20)
                                {
                                    v.y = w.y - 20;
                                }
                            }
                        }
                    }
                }
            }
            foreach (var v1 in Vehicle.All)
            {
                float radius = 200;
                if (v1.collision == true)
                {
                    foreach (var v2 in Vehicle.All)
                    {
                        if (v1 != v2)
                        {
                            if (v2.collision == true)
                            {
                                float dist = GetDistanceBetweenCoords(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
                                if (dist < radius)
                                {
                                    float dir = GetHeading(v2.x, v2.z, v1.x, v1.z);
                                    v1.x = v1.x + (radius - dist) * Sin(dir);
                                    v1.z = v1.z + (radius - dist) * Cos(dir);

                                    v2.x = v2.x - (radius - dist) * Sin(dir);
                                    v2.z = v2.z - (radius - dist) * Cos(dir);
                                }
                            }
                        }
                    }
                }
            }
            foreach (var p1 in Ped.All)
            {
                float radius = 30;
                if (p1.type != "dead")
                {
                    if (p1.collision == true)
                    {
                        foreach (var p2 in Ped.All)
                        {
                            if (p1 != p2)
                            {
                                if (p2.type != "dead")
                                {
                                    if (p2.collision == true)
                                    {
                                        float dist = GetDistanceBetweenCoords(p1.x, p1.y + radius, p1.z, p2.x, p2.y + radius, p2.z);
                                        if (dist < radius)
                                        {
                                            float dir = GetHeading(p2.x, p2.z, p1.x, p1.z);
                                            p1.x = p1.x + (radius - dist) * Sin(dir);
                                            p1.z = p1.z + (radius - dist) * Cos(dir);

                                            p2.x = p2.x - (radius - dist) * Sin(dir);
                                            p2.z = p2.z - (radius - dist) * Cos(dir);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    foreach (var v in Vehicle.All)
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
                            oy = v.y + 50;
                            osy = 100;
                        }
                        var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, radius, p1.x, p1.y, p1.z);
                        if (col.collided == true)
                        {
                            p1.x = col.dot.x;
                            p1.y = col.dot.y;
                            p1.z = col.dot.z;
                            if (v.speed != 0)
                            {
                                p1.health -= Math.Abs(v.speed);
                                if (p1.health <= 0)
                                {
                                    p1.type = "dead";
                                }
                            }
                        }
                    }
                }
            }
            var lamps = Lamp.All;
            foreach (var l in Lamp.All)
            {
                if (l.collision == true)
                {
                    float ox = l.x;
                    float oz = l.z;
                    float oy = l.y;
                    float oh = l.ry;
                    float osx = 10;
                    float osy = 200;
                    float osz = 10;
                    var col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 20, player.x, player.y, player.z);
                    if (col.collided == true)
                    {
                        player.x = col.dot.x;
                        player.y = col.dot.y;
                        player.z = col.dot.z;
                        player.jumpblocker = false;
                    }
                    foreach (var v in Vehicle.All)
                    {
                        col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 100, v.x, v.y, v.z);
                        if (col.collided == true)
                        {
                            Point tmp = col.dot;
                            if (col.dot.x != v.x || col.dot.z != v.z)
                            {
                                float r = 200f;
                                float dist = GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z);
                                if (dist < r)
                                {
                                    if (v is Car)
                                    {
                                        var sound = ((Car)v).soundCol;
                                        sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\DEFORMATION_LOW_1.wav"));
                                        sound.Play();
                                        sound.Volume = ((r - dist) / r) / 3f;
                                    }
                                    if (v.speed > 1)
                                    {
                                        v.speed -= 0.1f;
                                    }
                                    else if (v.speed < -1)
                                    {
                                        v.speed += 0.1f;
                                    }
                                }
                            }
                            if (l.fall == false)
                            {
                                //var dir = GetHeading(col.dot.x, col.dot.z, v.x, v.z);
                                l.ry = v.ry;
                                l.collision = false;
                                l.lampcomp[1] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                                l.lampcomp[2] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                                l.lampcomp[3] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                                l.lampcomp[4] = new Component("cube", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                                l.fall = true;
                            }
                            v.x = col.dot.x;
                            v.y = col.dot.y;
                            v.z = col.dot.z;
                        }
                    }
                    foreach (var p in Ped.All)
                    {
                        col = ProcessCollision(ox, oy, oz, oh, osx, osy, osz, 20, p.x, p.y, p.z);
                        if (col.collided == true)
                        {
                            p.x = col.dot.x;
                            p.y = col.dot.y;
                            p.z = col.dot.z;
                        }
                    }
                }
            }
            foreach (var h in Hydrant.All)
            {
                if (h.collision == true)
                {
                    if (player.y >= h.y && player.y <= h.y + 50)
                    {
                        float radius = 20;
                        float dist = GetDistanceBetweenCoords(h.x, 0, h.z, player.x, 0, player.z);
                        if (dist < radius)
                        {
                            float dir = GetHeading(h.x, h.z, player.x, player.z);
                            player.x = player.x + (radius - dist) * Sin(dir);
                            player.z = player.z + (radius - dist) * Cos(dir);
                        }
                    }
                    foreach (var v in Vehicle.All)
                    {
                        if (v.y >= h.y && v.y <= h.y + 50)
                        {
                            float radius = 100;
                            float dist = GetDistanceBetweenCoords(h.x, 0, h.z, v.x, 0, v.z);
                            if (dist < radius)
                            {
                                float r = 200f;
                                float d = GetDistanceBetweenCoords(player.x, player.y, player.z, v.x, v.y, v.z);
                                if (d < r)
                                {
                                    if (v is Car)
                                    {
                                        var sound = ((Car)v).soundCol;
                                        sound.Open(new Uri(@"D:\Desktop\opengl2\OpenGL_1\Sounds\DEFORMATION_LOW_1.wav"));
                                        sound.Play();
                                        sound.Volume = ((r - d) / r) / 3f;
                                    }
                                    if (v.speed > 1)
                                    {
                                        v.speed -= 0.1f;
                                    }
                                    else if (v.speed < -1)
                                    {
                                        v.speed += 0.1f;
                                    }
                                }
                                if (h.broken == false)
                                {
                                    //var dir = GetHeading(col.dot.x, col.dot.z, vehs[j].x, vehs[j].z);
                                    h.rx = 90f;
                                    h.ry = v.ry;
                                    h.collision = false;
                                    h.hydrcomp[6] = new Component("cylinder", 0, 0, 0, -180, 0, 0, 5, 5, 100, 0, 128, 255, 100);
                                    h.hydrcomp[7] = new Component("cone", 0, 0, -190, 0, 0, 0, 50, 50, 100, 0, 128, 255, 100);
                                    h.hydrcomp[8] = new Component("cone", 0, 0, -190, 0, 0, 0, 100, 100, 50, 0, 128, 255, 100);
                                    h.broken = true;
                                    h.timer = 0;
                                }
                                float dir = GetHeading(h.x, h.z, v.x, v.z);
                                v.x = v.x + (radius - dist) * Sin(dir);
                                v.z = v.z + (radius - dist) * Cos(dir);
                            }
                        }
                    }
                }
            }
        }
        public static bool HasVehicleCollidedWithAnyObject(Vehicle veh)
        {
            foreach (var o in Object.All)
            {
                int radius = 100;
                var col = ProcessCollision(o.x, o.y, o.z, o.ry, o.sx, o.sy, o.sz, radius, veh.x, veh.y, veh.z);
                if (col.collided == true)
                {
                    return true;
                }
            }
            return false;
        }
    }
}
