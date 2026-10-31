// sketch_ritmo3: las tres maneras del ritmo.
// Repetición (igual intervalo), alternancia (dos elementos que se turnan)
// y progresión (el intervalo crece). Cada una en su propia imagen.

void setup() {
  size(400, 400);
  int n = 400;

  // 1) repetición: el mismo elemento, el mismo intervalo
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      stroke(((y / 20) % 2 == 0) ? 255 : 0);
      point(x, y);
    }
  save("ritmo3_repeticion.png");

  // 2) alternancia: dos elementos que se turnan (ancho y estrecho)
  background(0);
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      stroke(((y % 40) < 30) ? 255 : 0);
      point(x, y);
    }
  save("ritmo3_alternancia.png");

  // 3) progresión: el intervalo crece
  background(0);
  int[] g = { 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65 };
  for (int y = 0; y < n; y++) {
    float f = franja(y, g);
    for (int x = 0; x < n; x++) {
      stroke(f);
      point(x, y);
    }
  }
  save("ritmo3_progresion.png");
}

// franjas de grosores dados (alternando negro y blanco)
float franja(float y, int[] grosores) {
  float total = 0;
  for (int i = 0; i < grosores.length; i++) {
    total += grosores[i];
    if (y < total) return (i % 2 == 0) ? 255 : 0;
  }
  return 0;
}
