// sketch_3flags: tres banderas anidadas (Three Flags, Jasper Johns).
// La misma forma a tres escalas, una dentro de otra: masa dentro de masa.
// El centro de masa cae en el centro: equilibrio por simetría.

Campo campo;

void setup() {
  size(400, 400);
  int n = 400;
  double[][] v = new double[n][n];
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      double b = 0;
      boolean franja = ((int) (y / 20)) % 2 == 0;   // franjas horizontales
      if (dentro(x, y, 60, 60, 340, 340)) b = franja ? 220 : 140;  // grande
      if (dentro(x, y, 110, 110, 290, 290)) b = franja ? 180 : 100; // mediana
      if (dentro(x, y, 160, 160, 240, 240)) b = franja ? 140 : 60;  // pequeña
      v[x][y] = b;
    }

  campo = new Campo(v);
  double[] c = campo.centroide();

  background(0);
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      stroke((float) v[x][y]);
      point(x, y);
    }

  // el centro de masa
  stroke(255, 0, 0);
  noFill();
  ellipse((float) c[0], (float) c[1], 14, 14);

  println("centro de masa: " + c[0] + ", " + c[1]);
  save("3flags.png");
}

boolean dentro(double x, double y, double x0, double y0, double x1, double y1) {
  return x >= x0 && x <= x1 && y >= y0 && y <= y1;
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
