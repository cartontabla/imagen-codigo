class Blob {
  int x0, y0, x1, y1;
  int repX, repY;
  double cx, cy;
  int area;
  int padre = -1;
}

class Nivel {
  ArrayList<Blob> blobs;
  int[][] etiqueta;
}

Nivel analizar(double[][] v, double t) {
  int w = v.length, h = v[0].length;
  Nivel n = new Nivel();
  n.blobs = new ArrayList<Blob>();
  n.etiqueta = new int[h][w];
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++)
      n.etiqueta[y][x] = -1;
  int[] dx = { 1, -1, 0, 0 };
  int[] dy = { 0, 0, 1, -1 };
  int[] pila = new int[w * h * 2];

  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++)
      if (v[x][y] > t && n.etiqueta[y][x] == -1) {
        int idx = n.blobs.size();
        Blob b = new Blob();
        b.x0 = b.x1 = x;
        b.y0 = b.y1 = y;
        b.repX = x;
        b.repY = y;
        double sx = 0, sy = 0, sp = 0;
        int area = 0, top = 0;
        pila[top++] = x;
        pila[top++] = y;
        n.etiqueta[y][x] = idx;
        while (top > 0) {
          int py = pila[--top];
          int px = pila[--top];
          double p = v[px][py];
          sx += px * p; sy += py * p; sp += p; area++;
          b.x0 = Math.min(b.x0, px); b.x1 = Math.max(b.x1, px);
          b.y0 = Math.min(b.y0, py); b.y1 = Math.max(b.y1, py);
          for (int k = 0; k < 4; k++) {
            int nx = px + dx[k], ny = py + dy[k];
            if (nx >= 0 && nx < w && ny >= 0 && ny < h &&
                v[nx][ny] > t && n.etiqueta[ny][nx] == -1) {
              n.etiqueta[ny][nx] = idx;
              pila[top++] = nx;
              pila[top++] = ny;
            }
          }
        }
        b.cx = sx / sp;
        b.cy = sy / sp;
        b.area = area;
        n.blobs.add(b);
      }
  return n;
}
