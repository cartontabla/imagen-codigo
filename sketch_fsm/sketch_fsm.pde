// sketch_fsm
// Máquina de estados finitos: autómata celular 1D (Regla 30).
// Cada celda es una FSM de 2 estados (VIVA=1, MUERTA=0); la regla 30
// es la transición: el estado siguiente depende de la celda y sus vecinas.

int cols = 200;      // celdas por fila
int rows = 100;      // generaciones
int cell = 2;        // píxeles por celda
int[] celdas;

void settings() {
  size(cols * cell, rows * cell);
}

void setup() {
  noLoop();
  background(255);

  celdas = new int[cols];
  celdas[cols / 2] = 1;   // estado inicial: una sola celda viva

  for (int y = 0; y < rows; y++) {
    dibujar(y);
    celdas = siguienteGeneracion();
  }

  save("fsm.png");
}

void dibujar(int y) {
  fill(0);
  for (int x = 0; x < cols; x++)
    if (celdas[x] == 1)
      rect(x * cell, y * cell, cell, cell);
}

// La transición: Regla 30 codificada en el número 30 (00011110).
int[] siguienteGeneracion() {
  int[] sig = new int[cols];
  for (int x = 0; x < cols; x++) {
    int izq = (x > 0) ? celdas[x - 1] : 0;
    int cen = celdas[x];
    int der = (x < cols - 1) ? celdas[x + 1] : 0;
    int patron = (izq << 2) | (cen << 1) | der;  // 0..7
    sig[x] = (30 >> patron) & 1;                 // el bit de la regla 30
  }
  return sig;
}
