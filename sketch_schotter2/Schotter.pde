class Schotter {
  int rows, cols;       // número de filas y columnas
  int sqrSiz;           // tamaño del cuadrado
  float rndStep;        // incremento angular
  float rndSum = 0;     // acumulador de perturbación rotacional
  int pad;              // margen exterior
  float rndVal;         // magnitud aleatoria
  float damp;           // factor de amortiguación

  Schotter(int rows, int cols, int siz, float step, float damp) {
    this.rows = rows;
    this.cols = cols;
    this.sqrSiz = siz;
    this.pad = 2 * sqrSiz;
    this.rndStep = step;
    this.damp = damp;
  }

  void draw() {
    for (int r = 1; r <= rows; r++) {
      rndSum += (r * rndStep); // Incremento del límite aleatorio por fila
      for (int c = 1; c <= cols; c++) {
        pushMatrix();
        rndVal = random(-rndSum, rndSum);
        float x = pad + (c * sqrSiz) - (0.5 * sqrSiz) + (rndVal * damp);
        float y = pad + (r * sqrSiz) - (0.5 * sqrSiz) + (rndVal * damp);
        translate(x, y);
        rotate(radians(rndVal));
        rect(0, 0, sqrSiz, sqrSiz);
        popMatrix();
      }
    }
  }
}
