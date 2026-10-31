// sketch_composicion03
// Un sistema completo de composición: la semilla decide el todo, y cada
// semilla produce una variación. La rejilla 3x3 muestra la familia.

void setup() {
  size(400, 400);
  noLoop();

  int n = 3;            // 3x3 variaciones
  float c = 400.0 / n;  // tamaño de cada celda
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      pushMatrix();
      translate(x * c, y * c);
      componer(y * n + x, c);
      popMatrix();
    }

  save("composicion03.png");
  exit();
}

void componer(int semilla, float c) {
  randomSeed(semilla);   // la semilla decide el todo
  fondo(c);              // 1. proceso
  elementos(c);          // 2. elementos
  atributos(c);          // 3. atributos
  relaciones(c);         // 4. relaciones
}

void fondo(float c) {
  fill(245);
  noStroke();
  rect(0, 0, c, c);
}

void elementos(float c) {
  fill(40);
  noStroke();
  int ne = (int) random(3, 6);   // cuántos elementos
  for (int i = 0; i < ne; i++) {
    float x = random(c * 0.2, c * 0.8);
    float y = random(c * 0.2, c * 0.8);
    float s = random(c * 0.12, c * 0.3);
    if (random(1) < 0.5)
      ellipse(x, y, s, s);
    else
      rect(x - s / 2, y - s / 2, s, s);
  }
}

void atributos(float c) {
  fill(210);
  noStroke();
  ellipse(c * 0.5, c * 0.5, c * 0.16, c * 0.16);
}

void relaciones(float c) {
  stroke(40, 40, 40, 70);
  strokeWeight(1);
  noFill();
  ellipse(c * 0.5, c * 0.5, c * 0.7, c * 0.7);   // el cierre que los reúne
}
