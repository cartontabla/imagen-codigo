// sketch_error
// El azar padecido: el programa hace lo que no le pediste.
// Un doble for que quiere copiar la imagen creyendo que el array de
// píxeles es un montón de colores sin orden. No lo es: tiene orden, fila
// a fila. Recorre el original de abajo arriba y escribe el destino de
// arriba abajo, y el retrato sale invertido.
// Compila, corre y no avisa.

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
  for (int y = height - 1; y >= 0; y--) {     // la fila empieza por abajo
    for (int x = 0; x < width; x++) {
      salida.pixels[d++] = retrato.pixels[y * width + x];
    }
  }
  salida.updatePixels();
}

void draw() {
  image(salida, 0, 0);
  save("error.png");
}
