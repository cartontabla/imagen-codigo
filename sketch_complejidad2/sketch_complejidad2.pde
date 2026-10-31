// sketch_complejidad00: un campo uniforme y ruido.
// A la izquierda, un solo valor (H=0); a la derecha, todos (H=8 bits).

void setup() {
  size(400, 400);
  randomSeed(7);

  for (int y = 0; y < 400; y++)
    for (int x = 0; x < 400; x++) {
      if (x < 200) stroke(128);             // uniforme: un solo valor
      else stroke((int) random(256));       // ruido: todos los valores
      point(x, y);
    }

  save("complejidad.png");
}
