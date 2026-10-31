class Campo {
  int w, h;
  double[][] v;

  Campo(double[][] valores) {
    v = valores;
    w = valores.length;
    h = valores[0].length;
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

  // el espectro: la magnitud de la DCT
  double[][] espectro() {
    double[][] D = dct2(v);
    for (int l = 0; l < h; l++)
      for (int k = 0; k < w; k++)
        D[k][l] = Math.abs(D[k][l]);
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
}
