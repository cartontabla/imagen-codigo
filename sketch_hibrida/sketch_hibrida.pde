// sketch_hibrida
// Síntesis: dos retratos se combinan en una tercera imagen que no es
// ninguna de las dos. De cerca se ve uno; de lejos, el otro.
// Un solo sketch: alinear, recortar y guardar.
//
//   flechas      mueven la segunda imagen (la de cerca), 2 px cada vez
//   espacio      alterna entre las dos, para comparar (parpadeo)
//   clic x2      primer clic: esquina superior izquierda del recorte
//                segundo clic: esquina inferior derecha
//                un tercer clic empieza un recorte nuevo
//   r            borra el recorte
//   + / -        radio del desenfoque
//   g            guarda la híbrida recortada y los ajustes

PImage  lejos, cerca, hibrida;
int     dx = 0, dy = 0;
float   radio = 10, realce = 1.6;
boolean comparando = false;
int     cx1 = -1, cy1 = -1, cx2 = -1, cy2 = -1;   // las dos esquinas del recorte

void setup() {
  size(800, 800);
  pixelDensity(1);
  lejos = loadImage("lejos.jpg");
  lejos.resize(width, height);
  cerca = loadImage("cerca.jpg");
  cerca.resize(width, height);
  calcula();
  // sin noLoop: draw() corre siempre, así el rectángulo sigue al ratón
}

void draw() {
  background(0);
  image(comparando ? cerca : hibrida, comparando ? dx : 0, comparando ? dy : 0);

  // el rectángulo del recorte, en vivo
  noFill();
  stroke(255, 40, 40);
  strokeWeight(1);
  if (cx1 >= 0 && cx2 < 0) {                        // eligiendo: sigue al ratón
    rect(cx1, cy1, mouseX - cx1, mouseY - cy1);
  } else if (cx1 >= 0 && cx2 >= 0) {                // ya elegido
    rect(min(cx1, cx2), min(cy1, cy2), abs(cx2 - cx1), abs(cy2 - cy1));
  }

  noStroke();
  fill(255);
  textSize(13);
  text("dx " + dx + "  dy " + dy + "  radio " + (int)radio
     + "   |  flechas: mover   espacio: comparar   clic x2: recortar   r: borrar   g: guardar",
       12, height - 12);
}

// recalcula la híbrida: solo cuando cambia algo, no en cada fotograma
void calcula() {
  PGraphics des = createGraphics(width, height);
  des.beginDraw();
  des.background(0);
  des.image(cerca, dx, dy, width, height);
  des.endDraw();

  PImage baja = lejos.get();
  baja.filter(BLUR, radio);
  PImage borrosa = des.get();
  borrosa.filter(BLUR, radio);

  baja.loadPixels();
  des.loadPixels();
  borrosa.loadPixels();

  hibrida = createImage(width, height, RGB);
  hibrida.loadPixels();
  for (int i = 0; i < hibrida.pixels.length; i++) {
    float r = red(baja.pixels[i])   + (red(des.pixels[i])   - red(borrosa.pixels[i]))   * realce;
    float g = green(baja.pixels[i]) + (green(des.pixels[i]) - green(borrosa.pixels[i])) * realce;
    float b = blue(baja.pixels[i])  + (blue(des.pixels[i])  - blue(borrosa.pixels[i]))  * realce;
    hibrida.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }
  hibrida.updatePixels();
}

void mousePressed() {
  if (cx1 < 0 || cx2 >= 0) {                  // primer clic, o empezar de nuevo
    cx1 = mouseX; cy1 = mouseY; cx2 = -1; cy2 = -1;
  } else {                                     // segundo clic: cerrar el rectángulo
    cx2 = mouseX; cy2 = mouseY;
    println("recorte: x " + min(cx1, cx2) + "  y " + min(cy1, cy2)
          + "  ancho " + abs(cx2 - cx1) + "  alto " + abs(cy2 - cy1));
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT)  dx -= 2;
    if (keyCode == RIGHT) dx += 2;
    if (keyCode == UP)    dy -= 2;
    if (keyCode == DOWN)  dy += 2;
    calcula();
  } else if (key == ' ') {
    comparando = !comparando;
  } else if (key == '+' || key == '=') {
    radio += 1; calcula();
  } else if (key == '-') {
    radio = max(1, radio - 1); calcula();
  } else if (key == 'r') {
    cx1 = cy1 = cx2 = cy2 = -1;
  } else if (key == 'g') {
    PImage salida = hibrida;
    if (cx1 >= 0 && cx2 >= 0) {                // si hay recorte, se aplica
      int x = min(cx1, cx2), y = min(cy1, cy2);
      int w = max(1, abs(cx2 - cx1)), h = max(1, abs(cy2 - cy1));
      salida = hibrida.get(x, y, w, h);
      saveStrings("recorte.txt", new String[]{"x=" + x, "y=" + y, "ancho=" + w, "alto=" + h});
    }
    salida.save("hibrida.png");
    saveStrings("alineado.txt", new String[]{"dx=" + dx, "dy=" + dy, "radio=" + radio});
    println("guardado: dx=" + dx + " dy=" + dy + " radio=" + radio);
  }
}
