// Schotter.pde
// La clase morfogenética: recorre la rejilla y desordena cada cuadrado
// en función de su fila. El azar crece hacia abajo.

class Schotter {
  int rows, cols;       // filas y columnas
  int sqrSiz;           // lado del cuadrado
  int pad;              // margen exterior
  float rndStep;        // incremento de la perturbación por fila
  float rndSum = 0;     // acumulador del límite aleatorio
  float rndVal;         // magnitud aleatoria de cada cuadrado
  float damp;           // amortiguación de la traslación

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
      rndSum += (r * rndStep);   // el límite del azar crece con la fila
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
