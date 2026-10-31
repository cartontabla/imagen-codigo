// sketch_complejidad3: mide orden y complejidad de todas las imágenes de
// data/ y las sitúa en el plano (orden, complejidad) con un número.

Campo campo;

void setup() {
  size(400, 400);
  noLoop();

  // 1) listar y filtrar las imágenes de data/
  String[] todos = listPaths(dataPath(""));
  java.util.ArrayList<String> imgs = new java.util.ArrayList<String>();
  if (todos != null)
    for (String f : todos) {
      String lf = f.toLowerCase();
      if (lf.endsWith(".png") || lf.endsWith(".jpg") || lf.endsWith(".jpeg"))
        imgs.add(f);
    }
  java.util.Collections.sort(imgs);

  // 2) el plano
  background(255);
  stroke(0);
  line(40, 360, 360, 360);    // eje complejidad (x)
  line(40, 360, 40, 40);      // eje orden (y)
  stroke(200);
  line(40, 360, 360, 40);     // diagonal: orden = complejidad

  // 3) medir y situar cada imagen
  for (int i = 0; i < imgs.size(); i++) {
    String nombre = imgs.get(i);
    PImage img = loadImage(nombre);
    if (img == null) { println("no encuentro " + nombre); continue; }
    img.loadPixels();
    if (img.width > 400) {
      // resize nearest-neighbor: conserva los valores exactos (sin interpolar)
      int nw = 400;
      int nh = (int) (img.height * 400.0 / img.width);
      PImage r = createImage(nw, nh, RGB);
      r.loadPixels();
      for (int y = 0; y < nh; y++)
        for (int x = 0; x < nw; x++) {
          int sx = x * img.width / nw;
          int sy = y * img.height / nh;
          r.pixels[y * nw + x] = img.pixels[sy * img.width + sx];
        }
      r.updatePixels();
      img = r;
    }
    int w = img.width, h = img.height;

    // histograma (imagen completa)
    double[] hist = new double[256];
    for (int j = 0; j < img.pixels.length; j++)
      hist[(int) brightness(img.pixels[j])]++;

    // el campo completo (sin reducción)
    double[][] v = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++)
        v[x][y] = brightness(img.pixels[y * w + x]);

    campo = new Campo(v);

    double complejidad = campo.entropia(hist) / 8.0;
    double[][] E = campo.espectro();
    double Hmax = Math.log(w * h - 1) / Math.log(2);   // log2 del tamaño real
    double orden = 1 - campo.entropia(E) / Hmax;

    // el punto
    float px = 40 + (float) complejidad * 320;
    float py = 360 - (float) orden * 320;

    stroke(255, 0, 0);
    fill(255, 0, 0);
    ellipse(px, py, 8, 8);

    // el número
    fill(0);
    textSize(10);
    text(str(i + 1), px + 6, py - 6);

    // imprimir
    println((i + 1) + ": " + nombre + " -> orden=" + String.format("%.3f", orden)
            + "  complejidad=" + String.format("%.3f", complejidad));
  }

  save("complejidad_plano.png");
}
