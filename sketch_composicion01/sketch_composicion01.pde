// sketch_composicion01
// Componer es decidir, capa a capa. La composición se construye apilando
// cuatro decisiones: el fondo, los elementos, los atributos y las relaciones.

void setup() {
  size(400, 400);
  noLoop();
  componer();
  save("composicion01.png");
  exit();
}

void componer() {
  fondo();       // 1. proceso: el soporte
  elementos();   // 2. elementos: qué formas entran
  atributos();   // 3. atributos: tamaño y color
  relaciones();  // 4. relaciones: cómo se relacionan
}

// 1. El fondo: el soporte sobre el que se decide.
void fondo() {
  background(245);
}

// 2. Los elementos: cuatro círculos.
void elementos() {
  noStroke();
  fill(40);
  ellipse(100, 100, 80, 80);
  ellipse(300, 100, 80, 80);
  ellipse(100, 300, 80, 80);
  ellipse(300, 300, 80, 80);
}

// 3. Los atributos: un rectángulo central, más claro.
void atributos() {
  noStroke();
  fill(210);
  rect(165, 165, 70, 70);
}

// 4. Las relaciones: líneas que unen los pares (simetría y proximidad).
void relaciones() {
  stroke(40, 40, 40, 110);
  strokeWeight(2);
  line(100, 100, 300, 100);
  line(100, 300, 300, 300);
  line(100, 100, 100, 300);
  line(300, 100, 300, 300);
}
