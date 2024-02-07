namespace OpenGL_1
{
    public class Entity
    {
        public string type;
        public float x, y, z;
        public float rx, ry, rz;
        public float sx, sy, sz;
        public bool collision = true;
        public void SetPos(float x, float y, float z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        public bool IsDead()
        {
            return type == "dead";
        }
    }
}
