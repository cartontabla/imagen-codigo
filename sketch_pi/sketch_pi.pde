// sketch_pi — π sobre SOS
// Los decimales de π entran por la derecha y se deslizan a la izquierda como
// un flujo continuo y a velocidad constante (igual que el código original).
// El SOS es una máscara fija: las celdas 0 son dos cuadrados negros opacos
// por los que los dígitos pasan POR DEBAJO, sin detenerse ni acelerarse.
//
// Morse canónico: SOS = ··· −−− ···
// Convención: punto = 1 celda, raya = 2 celdas, hueco entre letras = 1 celda.
//   ··· −−− ···  →  111 0 111111 0 111   (14 celdas; 1 = ventana, 0 = hueco)
//
// Cada dígito lleva el color de su posición en el código de resistencias:
// 0 negro, 1 marrón, 2 rojo … 9 blanco. El punto decimal es blanco sobre negro.

import java.math.BigInteger;

int cell = 200;    // lado del cuadrado
int margin = 0;   // margen horizontal

int[] sos = {1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1};  // 14 celdas

float speed = 2;   // velocidad constante (px por frame)

ArrayList<Float> positions = new ArrayList<Float>();
ArrayList<String> tokens = new ArrayList<String>();  // "0".."9" o "."

color[] digitColors = {
  color(0, 0, 0),        // 0 negro
  color(101, 67, 33),    // 1 marrón
  color(255, 0, 0),      // 2 rojo
  color(255, 140, 0),    // 3 naranja
  color(255, 255, 0),    // 4 amarillo
  color(0, 255, 0),      // 5 verde
  color(0, 0, 255),      // 6 azul
  color(148, 0, 211),    // 7 violeta
  color(128, 128, 128),  // 8 gris
  color(255, 255, 255)   // 9 blanco
};

PiDigitGenerator gen;
PFont font;

boolean started = false;    // aún no se ha emitido el "3"
boolean pointAdded = false; // aún no se ha emitido el "."

void settings() {
  size(2 * margin + sos.length * cell, cell);
  smooth();
  pixelDensity(1);
}

void setup() {
  background(0);
  frameRate(60);

  font = createFont("Arial Black", cell * 0.55);
  textFont(font);
  textSize(cell * 0.55);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  gen = new PiDigitGenerator();

  // el primer dígito ("3") entra por la derecha
  tokens.add(nextToken());
  positions.add((float) width);
}

void draw() {
  background(0);

  // añadir una ficha cuando la última deja sitio a su izquierda
  if (positions.isEmpty() || positions.get(positions.size() - 1) <= width - cell) {
    tokens.add(nextToken());
    positions.add((float) width);
  }

  // dibujar las fichas deslizándose a velocidad constante
  for (int j = 0; j < tokens.size(); j++) {
    String t = tokens.get(j);
    float x = positions.get(j);

    if (t.equals(".")) {
      fill(255);                 // punto decimal: blanco sobre negro
      noStroke();
      ellipse(x, height / 2.0, cell * 0.28, cell * 0.28);
    } else {
      int d = int(t);
      color bg = digitColors[d];
      fill(bg);
      noStroke();
      rect(x, height / 2.0, cell, cell);
      fill(contrastColor(bg));
      text(t, x, height / 2.0);
    }

    positions.set(j, x - speed);
  }

  // retirar las fichas que salen por completo
  while (!positions.isEmpty() && positions.get(0) < -cell / 2.0) {
    positions.remove(0);
    tokens.remove(0);
  }

  // máscara SOS: cuadrados negros opacos sobre los huecos (0)
  fill(0);
  noStroke();
  for (int i = 0; i < sos.length; i++) {
    if (sos[i] == 0) {
      rect(margin + i * cell + cell / 2.0, height / 2.0, cell, cell);
    }
  }
}

String nextToken() {
  if (!started)   { started = true;    return str(gen.next()); } // "3"
  if (!pointAdded) { pointAdded = true; return "."; }            // "."
  return str(gen.next());                                         // 1 4 1 5 9 …
}

color contrastColor(color c) {
  float lum = 0.299 * red(c) + 0.587 * green(c) + 0.114 * blue(c);
  return (lum > 140) ? color(0) : color(255);
}

void keyPressed() {
  if (key == 's' || key == 'S') save("pi_sos.png");
}
