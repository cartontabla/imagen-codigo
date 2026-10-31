// la imagen como campo escalar: un número por punto
class Campo {
  int w, h;
  double[][] v;

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
}
