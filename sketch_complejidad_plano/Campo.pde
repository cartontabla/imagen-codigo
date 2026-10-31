class Campo {
  int w, h;
  double[][] v;

  Campo(double[][] valores) {
    v = valores;
    w = valores.length;
    h = valores[0].length;
  }

  // ---------- dirección ----------
  // el gradiente (diferencias centrales)
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

  // el gradiente hacia delante (Hudgin) con condición Neumann
  double[][] gxAdelante() {
    double[][] g = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w - 1; x++)
        g[x][y] = v[x + 1][y] - v[x][y];
    return g;
  }

  double[][] gyAdelante() {
    double[][] g = new double[w][h];
    for (int y = 0; y < h - 1; y++)
      for (int x = 0; x < w; x++)
        g[x][y] = v[x][y + 1] - v[x][y];
    return g;
  }

  // la inversa: resolver lap(r) = div(gx, gy) por DCT (exacto)
  double[][] reconstruir(double[][] gx, double[][] gy) {
    double[][] div = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++) {
        double gxr = gx[x][y];
        double gxl = (x > 0) ? gx[x - 1][y] : 0;
        double gyd = gy[x][y];
        double gyu = (y > 0) ? gy[x][y - 1] : 0;
        div[x][y] = (gxr - gxl) + (gyd - gyu);
      }

    double[][] D = dct2(div);
    for (int l = 0; l < h; l++)
      for (int k = 0; k < w; k++) {
        double lam = 2 * Math.cos(Math.PI * k / w) + 2 * Math.cos(Math.PI * l / h) - 4;
        D[k][l] = (k == 0 && l == 0) ? 0 : D[k][l] / lam;
      }

    return idct2(D);
  }

  // DCT-II ortonormal, separable
  double[][] dct2(double[][] x) {
    double[][] t = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int kx = 0; kx < w; kx++) {
        double s = 0;
        for (int xx = 0; xx < w; xx++)
          s += x[xx][y] * Math.cos(Math.PI * kx * (xx + 0.5) / w);
        t[kx][y] = s * (kx == 0 ? Math.sqrt(1.0 / w) : Math.sqrt(2.0 / w));
      }
    double[][] o = new double[w][h];
    for (int kx = 0; kx < w; kx++)
      for (int ky = 0; ky < h; ky++) {
        double s = 0;
        for (int yy = 0; yy < h; yy++)
          s += t[kx][yy] * Math.cos(Math.PI * ky * (yy + 0.5) / h);
        o[kx][ky] = s * (ky == 0 ? Math.sqrt(1.0 / h) : Math.sqrt(2.0 / h));
      }
    return o;
  }

  // DCT-III (la inversa), separable
  double[][] idct2(double[][] X) {
    double[][] t = new double[w][h];
    for (int kx = 0; kx < w; kx++)
      for (int yy = 0; yy < h; yy++) {
        double s = 0;
        for (int ky = 0; ky < h; ky++)
          s += (ky == 0 ? Math.sqrt(1.0 / h) : Math.sqrt(2.0 / h)) * X[kx][ky] * Math.cos(Math.PI * ky * (yy + 0.5) / h);
        t[kx][yy] = s;
      }
    double[][] o = new double[w][h];
    for (int yy = 0; yy < h; yy++)
      for (int xx = 0; xx < w; xx++) {
        double s = 0;
        for (int kx = 0; kx < w; kx++)
          s += (kx == 0 ? Math.sqrt(1.0 / w) : Math.sqrt(2.0 / w)) * t[kx][yy] * Math.cos(Math.PI * kx * (xx + 0.5) / w);
        o[xx][yy] = s;
      }
    return o;
  }

  // ---------- equilibrio ----------
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

  // ---------- ritmo ----------
  // el espectro: la magnitud de la DCT, sin ruido numérico
  double[][] espectro() {
    double[][] D = dct2(v);
    for (int l = 0; l < h; l++)
      for (int k = 0; k < w; k++)
        D[k][l] = Math.abs(D[k][l]);
    for (int l = 0; l < h; l++)
      for (int k = 0; k < w; k++)
        if (D[k][l] < 1e-6) D[k][l] = 0;
    return D;
  }

  // la frecuencia dominante: el pico del espectro, sin la componente continua
  int[] frecuenciaDominante() {
    double[][] E = espectro();
    int fk = 0, fl = 0;
    double max = -1;
    for (int l = 0; l < h; l++)
      for (int k = 0; k < w; k++)
        if (!(k == 0 && l == 0) && E[k][l] > max) {
          max = E[k][l];
          fk = k;
          fl = l;
        }
    return new int[]{ fk, fl };
  }

  // ---------- complejidad ----------
  // la entropía de una distribución: H = -Σ p log₂ p (en bits)
  double entropia(double[] dist) {
    double total = 0, H = 0;
    for (int i = 0; i < dist.length; i++) total += dist[i];
      if (total == 0) return H;
    for (int i = 0; i < dist.length; i++) {
      double p = dist[i] / total;
      if (p > 0) H -= p * Math.log(p) / Math.log(2);
    }
    return H;
  }

  // la entropía espectral: el espectro aplanado, sin la componente continua
  double entropia(double[][] E) {
    int ew = E.length, eh = E[0].length;
    double[] dist = new double[ew * eh - 1];
    int idx = 0;
    for (int ky = 0; ky < eh; ky++)
      for (int kx = 0; kx < ew; kx++) {
        if (kx == 0 && ky == 0) continue;   // quitar el brillo medio
        dist[idx++] = E[kx][ky];
      }
    return entropia(dist);
  }
}
