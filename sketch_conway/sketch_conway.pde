// sketch_conway
// Juego de la Vida de Conway: cada generación es una imagen; la secuencia de
// generaciones es el movimiento (progresión). Guarda una instantánea cada 5
// generaciones, en una rejilla de 4 filas por 6 columnas: cwXY.png (X fila, Y columna).

int n = 50;                  // celdas por lado
int[][] mundo;
int generacion = 0;
int captura = 0;
int filas = 6, columnas = 6;

void setup() {
  size(400, 400);
  randomSeed(42);            // semilla fija: misma secuencia cada ejecución
  mundo = new int[n][n];

  // sembrar células vivas (~40 %)
  for (int i = 0; i < n * n * 0.4; i++)
    mundo[int(random(n))][int(random(n))] = 1;

  noStroke();
}

void draw() {
  // 1) dibujar la generación actual
  background(0);
  float c = float(width) / n;
  fill(255);
  for (int x = 0; x < n; x++)
    for (int y = 0; y < n; y++)
      if (mundo[x][y] == 1) rect(x * c, y * c, c, c);

  // 2) guardar una instantánea cada 5 generaciones
  if (generacion % 5 == 0 && captura < filas * columnas) {
    int f = captura / columnas;    // fila
    int co = captura % columnas;   // columna
    save(String.format("%01d%01d", f+1, co+1) + ".png");
    captura++;
  }

  // 3) calcular la siguiente generación
  mundo = siguiente(mundo);
  generacion++;

  // 4) terminar al completar la rejilla
  if (captura >= filas * columnas) exit();
}

// Regla de Conway: una célula vive con 2 o 3 vecinas; nace con 3; si no, muere.
int[][] siguiente(int[][] a) {
  int[][] b = new int[n][n];
  for (int x = 0; x < n; x++)
    for (int y = 0; y < n; y++) {
      int v = vecinos(a, x, y);
      if (a[x][y] == 1) b[x][y] = (v == 2 || v == 3) ? 1 : 0;
      else              b[x][y] = (v == 3) ? 1 : 0;
    }
  return b;
}

// Vecinas vivas (la rejilla se cierra como un toro para evitar bordes).
int vecinos(int[][] a, int x, int y) {
  int v = 0;
  for (int i = -1; i <= 1; i++)
    for (int j = -1; j <= 1; j++) {
      if (i == 0 && j == 0) continue;
      v += a[(x + i + n) % n][(y + j + n) % n];
    }
  return v;
}
