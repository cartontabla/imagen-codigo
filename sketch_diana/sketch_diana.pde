// sketch_diana: una diana grande con tres rectángulos encima.
// Como los Target de Jasper Johns: la diana (grande, centrada) frente a
// los rectángulos (pequeños, arriba). El centroide mide el tamaño; el ojo
// siente también la posición ---arriba pesa más---.

Campo campo;

void setup() {
  size(400, 400);
  int n = 400;
  double[][] v = new double[n][n];
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      double b = 0;
      // la diana: anillos concéntricos, grande y centrada
      double cx = 200, cy = 225;
      b += anillo(x, y, cx, cy, 0, 35, 200);    // centro
      b += anillo(x, y, cx, cy, 35, 70, 80);
      b += anillo(x, y, cx, cy, 70, 105, 220);
      b += anillo(x, y, cx, cy, 105, 140, 80);
      b += anillo(x, y, cx, cy, 140, 175, 220); // anillo exterior
      // tres rectángulos, arriba
      if (dentro(x, y, 0, 0, 133, 50)) b = 100;
      if (dentro(x, y, 133, 0, 266, 50)) b = 200;
      if (dentro(x, y, 266, 0, 400, 50)) b = 80;
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
  save("diana.png");
}

double anillo(double x, double y, double cx, double cy, double ri, double re, double b) {
  double d = Math.sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
  return (d >= ri && d < re) ? b : 0;
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
