// sketch_ritmo00: franjas de igual y de distinto grosor.
// Las franjas de igual grosor (negro-blanco repetidas) muestran ritmo;
// las de distinto grosor no.

void setup() {
  size(400, 400);
  int n = 400;

  // grosores de las franjas irregulares (sin periodo fijo)
  int[] g = { 20, 35, 12, 28, 45, 15, 22, 40, 18, 30, 10, 38, 25, 16, 33, 21 };

  for (int y = 0; y < n; y++) {
    float regular = ((y / 20) % 2 == 0) ? 255 : 0;   // igual grosor
    float irregular = franja(y, g);                   // distinto grosor

    for (int x = 0; x < 200; x++) {
      stroke(regular);
      point(x, y);
    }
    for (int x = 200; x < 400; x++) {
      stroke(irregular);
      point(x, y);
    }
  }

  save("ritmo.png");
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
