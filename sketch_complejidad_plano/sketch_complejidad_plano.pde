// sketch_complejidad_plano: el plano (orden, complejidad).
// Cada imagen es un punto; ambos ejes normalizados entre 0 y 1.

Campo campo;

void setup() {
  size(400, 400);
  noLoop();
  randomSeed(7);

  int n = 200;
  String[] nombres = { "uniforme", "franjas", "ruido" };
  double HmaxEsp = Math.log(n * n - 1) / Math.log(2);   // log2(39999) ≈ 15,29

  // el plano
  background(255);
  stroke(0);
  line(40, 360, 360, 360);    // eje complejidad (x)
  line(40, 360, 40, 40);      // eje orden (y)
  stroke(200);
  line(40, 360, 360, 40);     // diagonal: orden = complejidad

  for (int p = 0; p < 3; p++) {
    double[][] v = new double[n][n];
    for (int y = 0; y < n; y++)
      for (int x = 0; x < n; x++) {
        if (p == 0)      v[x][y] = 128;
        else if (p == 1) v[x][y] = ((y / 5) % 2 == 0) ? 255 : 0;   // franjas
        else             v[x][y] = (int) random(256);              // ruido
      }

    campo = new Campo(v);

    // complejidad = H histograma / log2(256) = H / 8
    double[] hist = new double[256];
    for (int y = 0; y < n; y++)
      for (int x = 0; x < n; x++)
        hist[(int) v[x][y]]++;
    double complejidad = campo.entropia(hist) / 8.0;

    // orden = redundancia = 1 - H espectral / Hmax
    double[][] E = campo.espectro();
    double orden = 1 - campo.entropia(E) / HmaxEsp;

    float px = 40 + (float) complejidad * 320;
    float py = 360 - (float) orden * 320;

    stroke(255, 0, 0);
    fill(255, 0, 0);
    ellipse(px, py, 10, 10);

    println(nombres[p] + " -> orden=" + String.format("%.3f", orden) + "  complejidad=" + String.format("%.3f", complejidad));
  }

  save("complejidad_plano.png");
}
