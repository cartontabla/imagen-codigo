// sketch_equilibrio03: tensión.
// Una sola masa desplazada: el centro de masa sale del centro
// y aparece la tensión, el vector que tira hacia el equilibrio.

Campo campo;

void setup() {
  size(400, 400);
  int n = 400;
  double[][] v = new double[n][n];
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++)
      v[x][y] = masa(x, y, 300, 200, 70);

  campo = new Campo(v);
  double[] c = campo.centroide();

  // dibujar el campo de pesos
  background(0);
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      stroke((float) v[x][y]);
      point(x, y);
    }

  // la tensión: del centro de masa al centro del marco
  float cx = (float) c[0], cy = (float) c[1];
  float dx = 200 - cx, dy = 200 - cy;
  float len = (float) Math.sqrt(dx * dx + dy * dy);
  float ux = dx / len, uy = dy / len;
  stroke(255, 0, 0);
  line(cx, cy, 200, 200);
  // cabeza de flecha
  line(200, 200, 200 - ux * 12 - uy * 6, 200 - uy * 12 + ux * 6);
  line(200, 200, 200 - ux * 12 + uy * 6, 200 - uy * 12 - ux * 6);
  noFill();
  ellipse(cx, cy, 14, 14);

  println("centro de masa: " + c[0] + ", " + c[1]);
  save("equilibrio03.png");
}

// una masa: un disco brillante de radio r centrado en (cx, cy)
double masa(double x, double y, double cx, double cy, double r) {
  double d = Math.sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
  return d < r ? 255 : 0;
}

class Campo {
  int w, h;
  double[][] v;

  Campo(double[][] valores) {
    v = valores;
    w = valores.length;
    h = valores[0].length;
  }

  // el centro de masa: la media ponderada por el peso
  double[] centroide() {
    double cx = 0, cy = 0, total = 0;
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++) {
        double p = v[x][y];
        cx += x * p;
        cy += y * p;
        total += p;
      }
    return new double[]{ cx / total, cy / total };
  }
}
