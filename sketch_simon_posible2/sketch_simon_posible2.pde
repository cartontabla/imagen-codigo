// sketch_simon_po2
// Convierte una imagen en un icono de 32×32 conservando los BORDES:
// reduce la imagen a la rejilla, detecta los cambios de brillo (bordes)
// y los dibuja con la retícula de Every Icon.
// 's' guarda, 'q' sale; flechas arriba/abajo ajustan el umbral.

PImage img;
int N = 32;
float umbral = 60;     // umbral de diferencia para considerar borde

void setup() {
  size(512, 512);
  img = loadImage("foto.jpg");   // pon tu imagen en data/
  img.resize(N, N);
  noLoop();
}

void draw() {
  background(255);
  int cell = width / N;

  // detectar bordes y dibujar celdas
  noStroke();
  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      float b0 = brightness(img.get(j, i));
      float bx = (j < N-1) ? brightness(img.get(j+1, i)) : b0;
      float by = (i < N-1) ? brightness(img.get(j, i+1)) : b0;
      float grad = abs(bx - b0) + abs(by - b0);
      fill(grad > umbral ? 0 : 255);
      rect(j * cell, i * cell, cell, cell);
    }

  // rejilla (líneas negras)
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i <= N; i++) {
    line(0, i * cell, N * cell, i * cell);    // horizontales
    line(i * cell, 0, i * cell, N * cell);    // verticales
  }
}

void keyPressed() {
  if (key == 's') save("simon_posible2.png");
  if (key == 'q' || key == 'Q') exit();
  if (keyCode == UP)   { umbral += 10; redraw(); }
  if (keyCode == DOWN) { umbral = max(0, umbral - 10); redraw(); }
}
