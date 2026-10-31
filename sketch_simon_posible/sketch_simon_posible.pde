// sketch_simon_posible
// Convierte una imagen en uno de los iconos posibles de Every Icon:
// la reduce a una rejilla de 32×32, la pasa a blanco y negro y la dibuja
// con la misma retícula. Cualquier imagen es uno de los 2^1024 iconos.
// Pulsa 's' para guardar, 'q' para salir; flechas arriba/abajo ajustan el umbral.

PImage img;
int N = 32;
float umbral = 128;     // brillo de corte entre negro y blanco

void setup() {
  size(512, 512);
  img = loadImage("foto.jpg");   // pon tu imagen en data/
  img.resize(N, N);                // la reduce a la rejilla
  noLoop();
}

void draw() {
  background(255);
  int cell = width / N;

  // celdas: negro o blanco según el brillo
  noStroke();
  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      float b = brightness(img.get(j, i));
      fill(b < umbral ? 0 : 255);
      rect(j * cell, i * cell, cell, cell);
    }

  // rejilla (líneas negras)
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i <= N; i++) {
    line(0, i * cell, N * cell, i * cell);
    line(i * cell, 0, i * cell, N * cell);
  }
}

void keyPressed() {
  if (key == 's') save("simon_posible.png");
  if (key == 'q' || key == 'Q') exit();
  if (keyCode == UP)   { umbral = min(255, umbral + 10); redraw(); }
  if (keyCode == DOWN) { umbral = max(0, umbral - 10); redraw(); }
}
