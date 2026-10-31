// sketch_lichtenstein
// Estilo Roy Lichtenstein: reduce la foto a unos pocos planos, asigna a
// cada plano un color de la paleta pop y su propia trama, y marca los
// contornos en negro.

PImage img;
int[]   cortes = {70, 130, 185, 218};   // fronteras entre planos
color[] paleta = {                      // color de cada plano
  color(0, 0, 0),        // 0 negro
  color(0, 87, 160),     // 1 azul
  color(227, 6, 19),     // 2 rojo
  color(255, 216, 0),    // 3 amarillo
  color(255, 255, 255)   // 4 blanco
};
int[]   tramas = {0, 2, 1, 3, 0};       // 0 liso | 1 puntos | 2 rayado / | 3 rayado \
color   tinta  = color(0);              // color de las tramas
int     paso   = 10;                    // rejilla del punto y período del rayado
int     grosor = 2;                     // grosor del trazo
float   diam   = 0.33;                  // radio del punto (fracción del paso)

void setup() {
  size(800, 800);
  pixelDensity(1);
  img = loadImage("foto.jpg");
  img = cuadrada(img);
  img.resize(width, height);
  img.filter(GRAY);
  img.filter(BLUR, 2);        // suaviza antes de posterizar: planos limpios
  img.loadPixels();
  noLoop();
}

void draw() {
  // 1. Los planos: cada píxel toma el color de su banda.
  loadPixels();
  for (int i = 0; i < width * height; i++) {
    pixels[i] = paleta[banda(img.pixels[i])];
  }
  updatePixels();

  // 2. La trama que le toca a cada plano.
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int i = y * width + x;
      if (trama(x, y, tramas[banda(img.pixels[i])])) {
        pixels[i] = tinta;
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

  save("lichtenstein.png");
}

// ¿lleva tinta el píxel (x, y) según la trama pedida?
boolean trama(int x, int y, int t) {
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
