// sketch_tramas
// Convierte una foto en imagen de cómic: reduce el tono a unos pocos
// planos y da a cada plano su propia trama (punto, rayado o plano liso).

PImage img;
int[] cortes = {70, 130, 185, 218};      // fronteras entre planos
int[] grises = {0, 100, 180, 230, 255};  // gris de cada plano
int[] tramas = {0, 2, 1, 3, 0};          // 0 liso | 1 puntos | 2 rayado / | 3 rayado \
int   paso   = 10;                       // rejilla del punto y período del rayado
int   grosor = 2;                        // grosor del trazo
float diam   = 0.33;                     // radio del punto (fracción del paso)

void setup() {
  size(800, 800);
  pixelDensity(1);   // sin esto, en pantallas Retina el búfer es 2x y el dibujo se descuadra
  img = loadImage("foto.jpg");
  img = cuadrada(img);
  img.resize(width, height);
  img.filter(GRAY);
  img.filter(BLUR, 2);        // suaviza antes de posterizar: planos limpios
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

  // 2. La trama que le toca a cada plano.
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int i = y * width + x;
      int b = banda(img.pixels[i]);
      if (tinta(x, y, tramas[b])) {
        pixels[i] = color(grises[b] > 128 ? 0 : 255);
      }
    }
  }
  updatePixels();

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

  save("tramas.png");
}

// ¿lleva tinta el píxel (x, y) según la trama pedida?
boolean tinta(int x, int y, int t) {
  if (t == 1) {                                              // puntos
    float dx = x % paso - paso / 2.0;
    float dy = y % paso - paso / 2.0;
    return dx * dx + dy * dy < (paso * diam) * (paso * diam);
  }
  if (t == 2) return (x + y) % paso < grosor;                // rayado /
  if (t == 3) return (x - y + width * paso) % paso < grosor; // rayado \
  return false;                                              // liso
}

// banda (0-4) a la que pertenece un color
int banda(color c) {
  float t = brightness(c);
  for (int i = 0; i < cortes.length; i++) if (t < cortes[i]) return i;
  return cortes.length;
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
