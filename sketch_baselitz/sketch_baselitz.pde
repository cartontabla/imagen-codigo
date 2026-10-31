// sketch_baselitz
// El error solicitado: exactamente el mismo doble for, ahora a propósito.
// Baselitz no se equivocó: decidió.

PImage retrato, salida;

void setup() {
  size(800, 800);
  pixelDensity(1);
  noLoop();

  retrato = loadImage("retrato.jpg");
  retrato.resize(width, height);
  retrato.loadPixels();

  salida = createImage(width, height, RGB);
  salida.loadPixels();

  int d = 0;
  for (int y = height - 1; y >= 0; y--) {     // la fila empieza por abajo, y lo sabe
    for (int x = 0; x < width; x++) {
      salida.pixels[d++] = retrato.pixels[y * width + x];
    }
  }
  salida.updatePixels();
}

void draw() {
  image(salida, 0, 0);
  save("baselitz.png");
}
