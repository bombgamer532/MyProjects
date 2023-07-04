using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Enemies
{
    static class Enemy
    {
        public static List<EnemyShip> enemies = new();
        public static List<(int x, int y)> enemyshots = new();
        public static void EnemySpawner()
        {
            Random rnd = new();
            while (true)
            {
                if (enemies.Count < 3)
                {
                    enemies.Add(new EnemyShip(rnd.Next(1, Program.width - 1), 1));
                }
                Thread.Sleep(5000);
            }
        }
        public static void EnemyMoving()
        {
            while (true)
            {
                Thread.Sleep(1000);
                for (int i = 0; i < enemies.Count; i++)
                {
                    enemies[i].SetPosition(enemies[i].x, enemies[i].y + 1);
                }
            }
        }
        public static void EnemyShooting()
        {
            while (true)
            {
                Parallel.For(0, enemies.Count, (i) => { enemyshots.Add((enemies[i].x, enemies[i].y + 1)); Thread.Sleep(5000); });
            }
        }
    }
}
