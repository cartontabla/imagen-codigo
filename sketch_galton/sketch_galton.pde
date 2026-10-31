// sketch_galton
// Mezcla: el promedio de muchos retratos. Ninguna de las partes está
// en el resultado; el resultado está en el cruce.

PImage[] caras;
int N = 22;               // 01.jpg ... 22.jpg en la carpeta data/

void setup() {
  size(600, 600);
  pixelDensity(1);
  caras = new PImage[N];
  for (int i = 0; i < N; i++) {
    caras[i] = loadImage(nf(i + 1, 2) + ".jpg");
    caras[i].resize(width, height);   // todas al mismo tamaño para poder sumarlas
    caras[i].loadPixels();
  }
  noLoop();
}

void draw() {
  // el acumulador va en float: los decimales son la mezcla
  float[] suma = new float[width * height * 3];
  for (int i = 0; i < N; i++) {
    for (int k = 0; k < width * height; k++) {
      color c = caras[i].pixels[k];
      suma[k * 3]     += red(c);
      suma[k * 3 + 1] += green(c);
      suma[k * 3 + 2] += blue(c);
    }
  }

  loadPixels();
  for (int k = 0; k < width * height; k++) {
    pixels[k] = color(suma[k * 3] / N, suma[k * 3 + 1] / N, suma[k * 3 + 2] / N);
  }
  updatePixels();

  save("media.png");
}
