// sketch_ritmo_dct: la DCT de tres imágenes.
// Carga ritmo3_repeticion.png, ritmo3_alternancia.png y ritmo3_progresion.png,
// calcula el espectro de cada una y guarda la imagen de la DCT con el pico
// marcado en rojo. La clase Campo vive en la pestaña Campo.pde.

Campo campo;
String[] entradas = { "ritmo3_repeticion.png", "ritmo3_alternancia.png", "ritmo3_progresion.png" };
String[] salidas  = { "ritmo_dct_repeticion.png", "ritmo_dct_alternancia.png", "ritmo_dct_progresion.png" };

void setup() {
  size(400, 400);
  noLoop();

  for (int p = 0; p < 3; p++) {
    PImage img = loadImage(entradas[p]);
    if (img == null) {
      println("no encuentro " + entradas[p]);
      continue;
    }
    img.loadPixels();
    int w = img.width, h = img.height;

    // el campo: el brillo de la imagen
    double[][] v = new double[w][h];
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++)
        v[x][y] = brightness(img.pixels[y * w + x]);

    campo = new Campo(v);
    double[][] E = campo.espectro();

    // el pico y el máximo, sin recomputar la DCT
    int fk = 0, fl = 0;
    double max = -1, maxE = 0;
    for (int l = 0; l < h; l++)
      for (int k = 0; k < w; k++)
        if (!(k == 0 && l == 0)) {
          maxE = Math.max(maxE, E[k][l]);
          if (E[k][l] > max) { max = E[k][l]; fk = k; fl = l; }
        }

    // dibujar el espectro en un buffer y guardarlo
    PGraphics pg = createGraphics(w, h);
    pg.beginDraw();
    pg.background(0);
    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++) {
        int kx = (x + w / 2) % w;   // componente continua al centro
        int ky = (y + h / 2) % h;
        float g = (kx == 0 && ky == 0) ? 0
                : (float) (255 * Math.log(1 + E[kx][ky]) / Math.log(1 + maxE));
        pg.stroke(g);
        pg.point(x, y);
      }
    pg.stroke(255, 0, 0);
    pg.noFill();
    pg.ellipse((fk + w / 2) % w, (fl + h / 2) % h, 10, 10);
    pg.endDraw();
    pg.save(salidas[p]);

    println(entradas[p] + " -> pico: (" + fk + ", " + fl + ")");
  }

  exit();
}
