// histograma: solo la distribución de brillos, con media, ±desv y moda
// La imagen se carga desde data/foto.jpg.

PImage img;
int[] hist = new int[256];

void setup() {
  size(400, 200);
  noSmooth();
  img = loadImage("foto.jpg");
  img.loadPixels();

  for (int i = 0; i < img.pixels.length; i++) {
    hist[int(brightness(img.pixels[i]))]++;
  }

  // estadísticas: media, desviación típica y moda
  long suma = 0;
  for (int b = 0; b < 256; b++) suma += (long) b * hist[b];
  float media = suma / (float) img.pixels.length;

  float s = 0;
  for (int b = 0; b < 256; b++) s += hist[b] * (b - media) * (b - media);
  float desv = sqrt(s / img.pixels.length);

  int moda = 0;
  for (int b = 1; b < 256; b++) if (hist[b] > hist[moda]) moda = b;

  noLoop();
  background(255);

  float y0 = 50, y1 = 350;          // el área del histograma
  int maxH = max(hist);
  noStroke();
  fill(0);
  for (int b = 0; b < 256; b++) {
    // escala logarítmica: un pico dominante (p. ej. el blanco) no aplasta el resto
    float h = map(log(1 + hist[b]), 0, log(1 + maxH), 0, y1 - y0);
    rect(20 + b * 1.4, y1 - h, 1.4, h);
  }

  // media (rojo), desviación (verde), moda (azul), escaladas al área
  stroke(200, 0, 0);
  line(20 + media * 1.4, y0, 20 + media * 1.4, y1);
  stroke(0, 140, 0);
  line(20 + (media - desv) * 1.4, y0, 20 + (media - desv) * 1.4, y1);
  line(20 + (media + desv) * 1.4, y0, 20 + (media + desv) * 1.4, y1);
  stroke(0, 0, 220);
  line(20 + moda * 1.4, y0, 20 + moda * 1.4, y1);

  println("media " + media + "  desviación " + desv + "  moda " + moda);
  println("píxeles en 255: " + hist[255] + " de " + img.pixels.length);
  save("histo.png");
}
