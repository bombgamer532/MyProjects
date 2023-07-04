using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Core.Enemies;
using Core.Player;

namespace Core
{
    static class Program
    {
        public const int width = 30;
        public const int height = 20;
        public static int score = 0;
        static void Main(string[] args)
        {
            new Thread(Main2).Start();
            Util.InitScene();
            new Thread(PlayerControl.Shooting).Start();
            new Thread(PlayerControl.Movement).Start();
            new Thread(ShotControl.Shots).Start();
            new Thread(Enemy.EnemySpawner).Start();
            new Thread(Enemy.EnemyMoving).Start();
            new Thread(Enemy.EnemyShooting).Start();
        }
        static void Main2()
        {
            while (true)
            {
                Thread.Sleep(50);
                for (int i = 0; i < Enemy.enemies.Count; i++)
                {
                    if (Enemy.enemies[i].x == PlayerShip.x && Enemy.enemies[i].y == PlayerShip.y)
                    {
                        Util.WriteAt(PlayerShip.x, PlayerShip.y, " ");
                        Util.GameOver();
                    }
                    if (Enemy.enemies[i].y >= height)
                    {
                        Util.GameOver();
                    }
                }
            }
        }
    }
}
