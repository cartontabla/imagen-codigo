// sketch_schotter
// Georg Nees, Schotter (1968), a partir de Jim Plaxco.
// Una rejilla de cuadrados que se desordena progresivamente:
// arriba, orden estricto; abajo, azar creciente.

int cols = 12;          // número de columnas
int rows = 22;          // número de filas
int sqrSiz = 30;        // tamaño del cuadrado
float rndStep = 0.22;   // incremento de la perturbación por fila
float damp = 0.45;      // amortiguación de la traslación

void settings() {
  size((cols + 4) * sqrSiz, (rows + 4) * sqrSiz);
  smooth();
}

void setup() {
  background(255);      // fondo blanco
  stroke(0);            // trazo negro
  strokeWeight(1.2);    // línea fina
  noFill();             // sin relleno
  rectMode(CENTER);     // coordenadas desde el centro del cuadrado
  noLoop();             // una sola ejecución
}

void draw() {
  Schotter scht = new Schotter(rows, cols, sqrSiz, rndStep, damp);
  scht.draw();
  save("schotter.png");
}
