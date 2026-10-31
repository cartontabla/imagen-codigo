class Campo {
  int w, h;
  double[][] v;                       // el campo escalar (la intensidad)

  Campo(double[][] valores) {
    v = valores;
    w = valores.length;
    h = valores[0].length;
  }

  // el gradiente: las dos componentes del campo vectorial
  double[][] gx() {
    double[][] g = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int x = 1; x < w - 1; x++)
        g[x][y] = (v[x + 1][y] - v[x - 1][y]) * 0.5;
    return g;
  }

  double[][] gy() {
    double[][] g = new double[w][h];
    for (int y = 1; y < h - 1; y++)
      for (int x = 0; x < w; x++)
        g[x][y] = (v[x][y + 1] - v[x][y - 1]) * 0.5;
    return g;
  }

  // la magnitud: el borde
  double[][] magnitud() {
    double[][] X = gx();
    double[][] Y = gy();
    double[][] m = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++)
        m[x][y] = Math.sqrt(X[x][y] * X[x][y] + Y[x][y] * Y[x][y]);
    return m;
  }

  // el laplaciano = la divergencia del gradiente
  double[][] laplaciano() {
    double[][] L = new double[w][h];
    for (int y = 1; y < h - 1; y++)
      for (int x = 1; x < w - 1; x++)
        L[x][y] = v[x + 1][y] + v[x - 1][y] + v[x][y + 1] + v[x][y - 1] - 4 * v[x][y];
    return L;
  }

  // la divergencia de un campo vectorial (X, Y)
  double[][] divergencia(double[][] X, double[][] Y) {
    double[][] d = new double[w][h];
    for (int y = 1; y < h - 1; y++)
      for (int x = 1; x < w - 1; x++)
        d[x][y] = (X[x + 1][y] - X[x - 1][y] + Y[x][y + 1] - Y[x][y - 1]) * 0.5;
    return d;
  }

  // el rotacional de un campo vectorial (X, Y): cero para un gradiente limpio
  double[][] rotacional(double[][] X, double[][] Y) {
    double[][] r = new double[w][h];
    for (int y = 1; y < h - 1; y++)
      for (int x = 1; x < w - 1; x++)
        r[x][y] = (-(X[x][y + 1] - X[x][y - 1]) + (Y[x + 1][y] - Y[x - 1][y])) * 0.5;
    return r;
  }

  // la inversa: reconstruir la imagen desde la divergencia (Poisson)
  double[][] reconstruir(double[][] div, int iter) {
    double[][] r = new double[w][h];
    for (int k = 0; k < iter; k++)
      for (int y = 1; y < h - 1; y++)
        for (int x = 1; x < w - 1; x++) {
          double lap = r[x + 1][y] + r[x - 1][y] + r[x][y + 1] + r[x][y - 1] - 4 * r[x][y];
          r[x][y] += 0.25 * (lap - div[x][y]);
        }
    return r;
  }
}
