// sketch_simon
// Every Icon (John F. Simon Jr., 1997): una rejilla de 32×32 que cuenta
// todas las combinaciones posibles, encendiendo y apagando celdas una a una.
// Fondo blanco, rejilla negra. Un incremento por segundo. 's' guarda, 'q' sale.

int N = 32;               // rejilla 32×32 (como el original)
int[][] celdas;           // 0 = blanca, 1 = negra
int ultimo = 0;           // instante del último incremento
int iteracion = 0;        // número de incrementos (la iteración)

void setup() {
  size(512, 512);
  celdas = new int[N][N];
}

void draw() {
  background(255);
  int cell = width / N;

  // celdas (negras o blancas)
  noStroke();
  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      fill(celdas[i][j] == 1 ? 0 : 255);
      rect(j * cell, i * cell, cell, cell);
    }

  // rejilla (líneas negras)
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i <= N; i++) {
    line(0, i * cell, N * cell, i * cell);    // horizontales
    line(i * cell, 0, i * cell, N * cell);    // verticales
  }

  // incrementar una vez por segundo
  if (millis() - ultimo > 1000) {
    ultimo = millis();
    incrementar();
  }
}

// cuenta en binario: la primera celda (fila 0, columna 0) es el bit
// menos significativo; el recorrido avanza fila a fila, columna a columna
void incrementar() {
  iteracion++;
  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      if (celdas[i][j] == 0) { celdas[i][j] = 1; return; }
      celdas[i][j] = 0;
    }
}

void keyPressed() {
  if (key == 's') save("simon" + iteracion + ".png");
  if (key == 'q' || key == 'Q') exit();
}
