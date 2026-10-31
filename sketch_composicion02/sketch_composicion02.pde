// sketch_composicion02
// La misma composición que composicion01, con otra ley de reparto:
// los mismos elementos, esta vez repartidos al azar (con semilla).
// Cambiar una sola capa —el reparto— cambia la composición entera.

void setup() {
  size(400, 400);
  noLoop();
  componer();
  save("composicion02.png");
  exit();
}

void componer() {
  fondo();       // el mismo fondo
  elementos();   // los mismos elementos, con otra ley de reparto
  atributos();   // los mismos atributos
  relaciones();  // las relaciones, según el reparto
}

// El mismo fondo que composicion01.
void fondo() {
  background(245);
}

// Los mismos cuatro círculos, repartidos al azar en lugar del cuadrado.
void elementos() {
  randomSeed(7);
  noStroke();
  fill(40);
  for (int i = 0; i < 4; i++)
    ellipse(random(80, 320), random(80, 320), 80, 80);
}

// El mismo rectángulo central.
void atributos() {
  noStroke();
  fill(210);
  rect(165, 165, 70, 70);
}

// El azar no crea pares que unir: las relaciones se desvanecen.
void relaciones() {
  // sin líneas: la composición queda suelta
}
