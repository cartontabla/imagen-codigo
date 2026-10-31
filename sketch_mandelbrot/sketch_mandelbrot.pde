// sketch_mandelbrot
// El conjunto de Mandelbrot: la regla más breve, la imagen más compleja.
// z = z*z + c, iterada sobre una rejilla. 's' guarda, 'q' sale.

void setup() {
  size(600, 600);
  pixelDensity(1);   // buffer de píxeles = tamaño lógico (evita el 2x retina)
  noLoop();

  loadPixels();
  for (int i = 0; i < width * height; i++) {
      int y = i / width;
      int x = i % width;
      float cr = map(x, 0, width, -2.2, 1);
      float ci = map(y, 0, height, -1.6, 1.6);
      float zr = 0, zi = 0;
      int n = 0;

      while (n < 200 && zr*zr + zi*zi < 4) {
        float t = zr*zr - zi*zi + cr;
        zi = 2*zr*zi + ci;
        zr = t;
        n++;
      }

      pixels[y*width + x] = (n == 200) ? color(0) : paleta(n);
  }
  updatePixels();
}

// azul Klein -> cian -> ámbar
color paleta(int n) {
  float t = n / 200.0;
  if (t < 0.5)
    return lerpColor(color(0, 47, 167), color(0, 180, 220), t * 2);
  else
    return lerpColor(color(0, 180, 220), color(255, 190, 60), (t - 0.5) * 2);
}

void keyPressed() {
  if (key == 's') save("mandelbrot.png");
  if (key == 'q' || key == 'Q') exit();
}
