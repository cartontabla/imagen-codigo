color c1 = color(255,255,0);
color c2 = color(0,255,0);

void setup() {
  pixelDensity(1);
  size(800, 800);
  smooth();
  noLoop();

  float cx = height/2, cy = width/2, r = 0.49 * width;

  PGraphics pg = createGraphics(800, 800);   // ARGB: conserva el alfa
  pg.beginDraw();
  pg.loadPixels();

  for (int y = 0; y < pg.height; y++) {
    for (int x = 0; x < pg.width; x++) {
      float dx = x - cx, dy = y - cy;
      float d2 = dx * dx + dy * dy;
      int i = y * pg.width + x;

      if (d2 > r * r) {
        pg.pixels[i] = color(0, 0, 0, 0);    // fuera: transparente
      } else {
        color base = lerpColor(c1, c2, x / float(pg.width));
        float dz = sqrt(r * r - d2);
        float nx = dx / r, ny = dy / r, nz = dz / r;
        float lx = -0.577, ly = -0.577, lz = 0.577;
        float difusa = max(0, nx * lx + ny * ly + nz * lz);
        float brillo = 0.22 + 0.78 * difusa;
        pg.pixels[i] = color(red(base) * brillo, green(base) * brillo, blue(base) * brillo);
      }
    }
  }

  pg.updatePixels();
  pg.endDraw();
  pg.save("esfera.png");   // guarda el PGraphics, con fondo transparente
  exit();
}
