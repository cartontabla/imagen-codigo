// sketch_stitching: coser dos mitades de distinto tono.
// La inversa del gradiente es resolver la ecuacion de Poisson por DCT.

PImage img;
Campo campo;

void setup() {
  size(400, 400);
  img = loadImage("foto.jpg");
  img.resize(200, 200);
  img.loadPixels();
  int w = img.width, h = img.height;

  // 1) dos mitades: la derecha más clara (un salto de +60)
  double[][] v = new double[w][h];
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++)
      v[x][y] = brightness(img.pixels[y * w + x]) + (x < w / 2 ? 0 : 60);

  campo = new Campo(v);

  // 2) el gradiente hacia delante (Hudgin), con condicion Neumann
  double[][] gx = campo.gxAdelante();
  double[][] gy = campo.gyAdelante();

  // 3) editar en el dominio del gradiente: quitar el salto de la costura
  //    el +60 aparece íntegro en la columna de la unión; se resta
  for (int y = 0; y < h; y++)
    gx[w / 2 - 1][y] -= 60;

  // 4) la inversa por Poisson: resolver lap(r) = div(gx, gy) por DCT
  double[][] r = campo.reconstruir(gx, gy);

  // 5) construir la imagen de salida RELLENA (no con puntos sueltos)
  PImage salida = createImage(w, h, RGB);
  salida.loadPixels();

  double mn = Double.MAX_VALUE, mx = -Double.MAX_VALUE;
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++) {
      mn = Math.min(mn, r[x][y]);
      mx = Math.max(mx, r[x][y]);
    }

  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++) {
      int g = (int) constrain(map((float) r[x][y], (float) mn, (float) mx, 0, 255), 0, 255);
      salida.pixels[y * w + x] = color(g);
    }
  salida.updatePixels();
  image(salida, 0, 0, 400, 400);
  save("stitch.png");

  // la costura (antes de editar), para comparar
  PImage costura = createImage(w, h, RGB);
  costura.loadPixels();
  double mn2 = Double.MAX_VALUE, mx2 = -Double.MAX_VALUE;
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++) {
      mn2 = Math.min(mn2, v[x][y]);
      mx2 = Math.max(mx2, v[x][y]);
    }
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++) {
      int g = (int) constrain(map((float) v[x][y], (float) mn2, (float) mx2, 0, 255), 0, 255);
      costura.pixels[y * w + x] = color(g);
    }
  costura.updatePixels();
  costura.save("stitch_costura.png");
}
