// Georg Nees, Schotter, based on Jim Plaxco (www.artsnova.com)
int cols = 12;          // número de columnas de cuadrados
int rows = 22;          // número de filas de cuadrados
int sqrSiz = 30;        // tamaño de cada cuadrado
float rndStep = 0.22;   // incremento de rotación en grados
float damp = 0.45;      // amortiguación del efecto aleatorio en la traslación

void settings() {
  int w = (cols + 4) * sqrSiz, h = (rows + 4) * sqrSiz;
  size(w, h);
  smooth();             // suavizado de líneas
}

void setup() {
  background(255);      // fondo blanco
  stroke(0);            // trazo negro
  noFill();             // sin relleno
  rectMode(CENTER);     // coordenadas referidas al centro del cuadrado
  noLoop();             // ejecución única
}

void draw() {
  Schotter scht = new Schotter(rows, cols, sqrSiz, rndStep, damp);
  scht.draw();
}
