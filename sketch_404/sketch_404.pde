// sketch_404
// JODI, 404 (1995): "%20Wrong" — el "404" en una matriz de 8×22
// (cuadrados blancos sobre negro), y un cuadrado blanco que se mueve
// entre dos posiciones (columnas 1 y 2). 's' guarda, 'q' sale.

// patrón del "404" (1 = blanco, 0 = negro), 8 filas × 22 columnas
int[][] patron = {
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0},
  {0,0,0,1,1,0,0,0,1,0,0,0,1,1,0,0,0,1,1,0,0,0},
  {0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,0,1,0,1,0,0,0},
  {0,1,0,0,1,0,0,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0},
  {0,1,1,1,1,1,1,0,1,1,0,0,0,1,0,1,1,1,1,1,1,0},
  {0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
};

int cell = 16;         // tamaño de la celda
int x0 = 44;           // margen izquierdo
int y0 = 56;           // margen superior
boolean dos = false;   // posición del cuadrado (col 1 o 2)
color[] c = {#FF0000, #00FF00, #0000FF, #FFFF00, #FF00FF, #00FFFF};
int idx;

void setup() {
  size(680, 480);
  idx = int(random(c.length));
}

void draw() {
  background(c[idx]);   // fondo cian (como la página original)
  noStroke();

  // matriz 8×22 con el "404"
  for (int i = 0; i < 8; i++)
    for (int j = 0; j < 22; j++) {
      fill(patron[i][j] == 1 ? 255 : 0);
      rect(x0 + j * cell, y0 + i * cell, cell, cell);
    }

  // cuadrado que alterna entre la columna 1 y la 2
  fill(255);
  int x = dos ? x0 + cell : x0;
  rect(x, 408, cell, cell);

  // cambiar de posición cada 500 ms
  if (frameCount % 30 == 0) dos = !dos;
}

void keyPressed() {
  if (key == 's') save("404.png");
  if (key == 'q' || key == 'Q') exit();
}
