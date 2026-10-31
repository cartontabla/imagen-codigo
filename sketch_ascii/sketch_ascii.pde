// sketch_ascii
// Convierte una imagen en arte ASCII (estilo Vuk Ćosić).
// Teclas:  +/-  tamaño del carácter   ·   [ ]  grosor (rampa)

PImage img;

// Rampas de caracteres, de fina a gruesa (densidad de tinta)
String[] rampas = {
  " .'`^,;:",            // 0: fina   (caracteres ligeros)
  " .:-=+*#%@",          // 1: media  (rampa estándar)
  "@#%*+=-:. "           // 2: gruesa (caracteres densos)
};

int rampa = 1;           // rampa actual
float tam = 8;           // tamaño del carácter (píxel)

void settings() {
  img = loadImage("foto.jpg");   // tu imagen (ponla en data/)
  size(img.width, img.height);
}

void setup() {
  noLoop();
}

void draw() {
  background(0);
  fill(0, 255, 0);                // verde terminal
  textFont(createFont("Monospaced", tam));

  int cols = (int) (width / tam);
  int rows = (int) (height / tam);

  PImage mini = img.copy();
  mini.resize(cols, rows);
  mini.loadPixels();

  String r = rampas[rampa];
  for (int y = 0; y < rows; y++)
    for (int x = 0; x < cols; x++) {
      float b = brightness(mini.pixels[y * cols + x]);
      int i = (int) map(b, 0, 255, r.length() - 1, 0);
      text(r.charAt(i), x * tam, y * tam);
    }
}

void keyPressed() {
  if (key == '+' || key == '=') { tam = min(24, tam + 1); redraw(); }
  if (key == '-')               { tam = max(2,  tam - 1); redraw(); }
  if (key == '[')               { rampa = max(0, rampa - 1); redraw(); }
  if (key == ']')               { rampa = min(rampas.length - 1, rampa + 1); redraw(); }
  if (key == 's' || key == 'S') { save("ASCII.png"); }

}
