// sketch_mosaico
// Convierte una imagen cualquiera en un mosaico de teselas.

PImage img;
int teselas = 48;       // teselas por lado
float junta = 0.10;     // grosor de la argamasa (fracción del paso)

void setup() {
  size(800, 800);
  img = loadImage("foto.jpg");
  img = cuadrada(img);          // recorte al cuadrado central
  img.resize(width, height);
  img.loadPixels();
  noLoop();
}

void draw() {
  background(255);
  noStroke();
  float paso = float(width) / teselas;
  float lado = paso * (1 - junta);
  for (int y = 0; y < teselas; y++) {
    for (int x = 0; x < teselas; x++) {
      fill(colorMedio(x, y, paso));
      rect(x * paso, y * paso, lado, lado);
    }
  }
  save("mosaico.png");
}

// recorta la imagen al cuadrado central
PImage cuadrada(PImage im) {
  int lado = min(im.width, im.height);
  return im.get((im.width - lado) / 2, (im.height - lado) / 2, lado, lado);
}

// color medio de la celda (cx, cy) de la retícula
color colorMedio(int cx, int cy, float paso) {
  int x0 = int(cx * paso), y0 = int(cy * paso);
  int x1 = min(int((cx + 1) * paso), img.width);
  int y1 = min(int((cy + 1) * paso), img.height);
  float r = 0, g = 0, b = 0;
  int n = 0;
  for (int y = y0; y < y1; y++) {
    for (int x = x0; x < x1; x++) {
      color c = img.pixels[y * img.width + x];
      r += red(c); g += green(c); b += blue(c);
      n++;
    }
  }
  return color(r / n, g / n, b / n);
}
