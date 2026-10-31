// sketch_equilibrio01: una masa y su contrapeso.
// Dos masas iguales y simétricas: el centro de masa cae en el centro.

Campo campo;

void setup() {
  size(400, 400);
  int n = 400;
  double[][] v = new double[n][n];
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++)
      v[x][y] = masa(x, y, 130, 200, 50) + masa(x, y, 270, 200, 50);

  campo = new Campo(v);
  double[] c = campo.centroide();

  // dibujar el campo de pesos
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
  save("equilibrio01.png");
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
