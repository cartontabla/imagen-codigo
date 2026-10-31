PImage img;
Campo campo;

void setup() {
  size(400, 400);
  img = loadImage("foto.jpg");
  img.loadPixels();

  int w = img.width, h = img.height;
  double[][] v = new double[w][h];
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++)
      v[x][y] = brightness(img.pixels[y * w + x]);

  campo = new Campo(v);
  double[][] gx = campo.gx();       // el gradiente ahora es un método
  double[][] gy = campo.gy();

  // el histograma de orientaciones (0..180), ponderado por la magnitud
  double[] hist = new double[180];
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++) {
      double m = Math.sqrt(gx[x][y] * gx[x][y] + gy[x][y] * gy[x][y]);
      if (m > 10) {
        double a = Math.toDegrees(Math.atan2(gy[x][y], gx[x][y]));
        if (a < 0) a += 180;
        hist[(int) a % 180] += m;
      }
    }

  // la orientación dominante: el pico del histograma
  int dom = 0;
  for (int a = 1; a < 180; a++) if (hist[a] > hist[dom]) dom = a;

  // dibujar la imagen y un muestreo de los vectores
  background(0);
  image(img, 0, 0, 400, 400);

  stroke(255, 40, 40);
  for (int y = 10; y < h; y += 20)
    for (int x = 10; x < w; x += 20) {
      double m = Math.sqrt(gx[x][y] * gx[x][y] + gy[x][y] * gy[x][y]);
      if (m > 10) {
        double a = Math.atan2(gy[x][y], gx[x][y]);
        double l = Math.min(8, m / 8);
        float X = map(x, 0, w, 0, 400);
        float Y = map(y, 0, h, 0, 400);
        line(X, Y, X + (float)(Math.cos(a) * l), Y + (float)(Math.sin(a) * l));
      }
    }
  save("dir.png");

  // el histograma de orientaciones
  PGraphics ph = createGraphics(400, 200);
  ph.beginDraw();
  ph.background(255);
  double maxH = 0;
  for (int a = 0; a < 180; a++) maxH = Math.max(maxH, hist[a]);
  ph.stroke(0);
  for (int a = 0; a < 180; a++) {
    float hh = (float)(160 * hist[a] / maxH);
    ph.line(a * 2.2f, 200, a * 2.2f, 200 - hh);
  }
  ph.stroke(0, 0, 220);
  ph.line(dom * 2.2f, 10, dom * 2.2f, 200);
  ph.endDraw();
  ph.save("dir_hist.png");

  println("orientación dominante: " + dom + " grados");
}
