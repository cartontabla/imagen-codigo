// sketch_ben_day
// Estilo Lichtenstein: posteriza la foto en planos de gris, marca los
// contornos en negro y añade puntos Ben-Day en las bandas medias.

PImage img;
int   paso   = 12;                       // rejilla de los puntos
int[] cortes = {70, 130, 185, 218};      // fronteras entre planos
int[] grises = {0, 100, 180, 230, 255};  // gris de cada plano
int[] puntos = {0, 38, 55, 0, 0};        // diámetro del punto por plano (%, 0 = sin punto)

void setup() {
  size(800, 800);
  pixelDensity(1);   // sin esto, en pantallas Retina el búfer es 2x y el dibujo se descuadra
  img = loadImage("foto.jpg");
  img = cuadrada(img);
  img.resize(width, height);
  img.filter(GRAY);
  img.filter(BLUR, 2);        // suaviza antes de posterizar: contornos limpios
  img.loadPixels();
  noLoop();
}

void draw() {
  // 1. Los planos: cada píxel toma el gris de su banda.
  loadPixels();
  for (int i = 0; i < width * height; i++) {
    pixels[i] = color(grises[banda(img.pixels[i])]);
  }
  updatePixels();

  // 2. Los puntos Ben-Day, solo en las bandas que los lleven.
  noStroke();
  for (int cy = 0; cy < height; cy += paso) {
    for (int cx = 0; cx < width; cx += paso) {
      int b = bandaDeCelda(cx, cy);
      if (puntos[b] == 0) continue;
      float d = paso * puntos[b] / 100.0;
      fill(grises[b] > 128 ? color(0) : color(255));
      ellipse(cx + paso / 2.0, cy + paso / 2.0, d, d);
    }
  }

  // 3. Los contornos: donde cambia el plano, un bloque de 3x3 en negro.
  loadPixels();
  for (int y = 1; y < height - 2; y++) {
    for (int x = 1; x < width - 2; x++) {
      if (contorno(x, y)) {
        for (int j = -1; j <= 1; j++)
          for (int k = -1; k <= 1; k++)
            pixels[(y + j) * width + (x + k)] = color(0);
      }
    }
  }
  updatePixels();

  save("ben_day.png");
}

// banda (0-4) a la que pertenece un color
int banda(color c) {
  float t = brightness(c);
  for (int i = 0; i < cortes.length; i++) if (t < cortes[i]) return i;
  return cortes.length;
}

// banda media de una celda de la rejilla
int bandaDeCelda(int x0, int y0) {
  float s = 0;
  int n = 0;
  for (int y = y0; y < min(y0 + paso, height); y++) {
    for (int x = x0; x < min(x0 + paso, width); x++) {
      s += brightness(img.pixels[y * width + x]);
      n++;
    }
  }
  return banda(color(n > 0 ? s / n : 255));
}

// hay contorno donde la banda cambia respecto al vecino
boolean contorno(int x, int y) {
  int b = banda(img.pixels[y * width + x]);
  return b != banda(img.pixels[y * width + x + 1])
      || b != banda(img.pixels[(y + 1) * width + x]);
}

// recorta la imagen al cuadrado central
PImage cuadrada(PImage im) {
  int lado = min(im.width, im.height);
  return im.get((im.width - lado) / 2, (im.height - lado) / 2, lado, lado);
}
