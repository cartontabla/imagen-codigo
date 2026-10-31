// sketch_glitch
// La serendipia: el error que la máquina produce sola, y que el artista
// reconoce y no arregla. Tres operaciones, las tres ordenadas:
//   1. ordenar por luminosidad los tramos oscuros de cada fila
//   2. estirar irregularmente en horizontal, por bandas
//   3. desplazar los canales: el rojo a un lado, el azul al otro

PImage img, salida;
int    umbral = 120;    // por debajo de este brillo, la fila se ordena
int    desvio = 9;      // cuánto se separan los canales

void setup() {
  size(800, 800);
  pixelDensity(1);
  randomSeed(11);       // el azar fijado, como en el goteo
  noLoop();

  img = loadImage("img.jpg");
  img.resize(width, height);
  img.loadPixels();

  // 1. ordenar por luminosidad los tramos oscuros de cada fila.
  //    Solo los oscuros: si se ordena la fila entera, el sujeto se va
  //    al borde izquierdo y el fondo claro ocupa el resto.
  for (int y = 0; y < height; y++) {
    int inicio = -1;
    for (int x = 0; x < width; x++) {
      boolean oscuro = brightness(img.pixels[y * width + x]) < umbral;
      if (oscuro && inicio < 0) inicio = x;
      if (inicio >= 0 && (!oscuro || x == width - 1)) {
        ordenarTramo(y, inicio, oscuro ? x : x - 1);
        inicio = -1;
      }
    }
  }

  // 2 y 3. estirar por bandas y separar los canales
  salida = createImage(width, height, RGB);
  salida.loadPixels();
  int y = 0;
  while (y < height) {
    int   alto   = int(random(8, 30));    // altura de la banda
    float escala = random(0.75, 1.35);    // el estirón: <1 encoge, >1 alarga
    float centro = random(width);         // desde dónde estira
    for (int k = 0; k < alto && y + k < height; k++) {
      for (int x = 0; x < width; x++) {
        int i  = (y + k) * width + x;
        int ix = constrain(int(centro + (x - centro) / escala), 0, width - 1);
        int ig = (y + k) * width + ix;
        int ir = (y + k) * width + constrain(ix - desvio, 0, width - 1);
        int ib = (y + k) * width + constrain(ix + desvio, 0, width - 1);
        salida.pixels[i] = color(red(img.pixels[ir]), green(img.pixels[ig]), blue(img.pixels[ib]));
      }
    }
    y += alto;
  }
  salida.updatePixels();
}

// ordena un tramo de la fila y por luminosidad (counting sort)
void ordenarTramo(int y, int desde, int hasta) {
  int n = hasta - desde + 1;
  if (n < 2) return;
  int[] cuenta = new int[256];
  for (int x = desde; x <= hasta; x++) {
    cuenta[int(brightness(img.pixels[y * width + x]))]++;
  }
  int[] sitio = new int[256];
  int acum = 0;
  for (int b = 0; b < 256; b++) {
    sitio[b] = acum;
    acum += cuenta[b];
  }
  color[] trozo = new color[n];
  for (int x = desde; x <= hasta; x++) {
    color c = img.pixels[y * width + x];
    trozo[sitio[int(brightness(c))]++] = c;
  }
  for (int k = 0; k < n; k++) {
    img.pixels[y * width + desde + k] = trozo[k];
  }
}

void draw() {
  image(salida, 0, 0);
  save("glitch.png");
}
