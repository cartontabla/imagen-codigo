// sketch_campo_escalar: la imagen como campo escalar y su gradiente.
// La clase Campo guarda la imagen y expone los operadores como métodos.

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

  // el borde: la magnitud del gradiente, normalizada a 0..255
  double[][] m = campo.magnitud();
  double max = 0;
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++)
      max = Math.max(max, m[x][y]);

  background(0);
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++) {
      stroke((int)(255 * m[x][y] / max));
      point(map(x, 0, w, 0, 400), map(y, 0, h, 0, 400));
    }
  save("borde.png");
}
