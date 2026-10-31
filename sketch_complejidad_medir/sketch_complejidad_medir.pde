// sketch_complejidad_medir: mide orden y complejidad de cualquier imagen.
// Carga una imagen de data/, calcula ambas entropías y las devuelve
// normalizadas entre 0 y 1.

Campo campo;
String archivo = "imagen.png";   // cambia aquí por tu imagen (en data/)

void setup() {
  size(400, 400);
  noLoop();

  PImage img = loadImage(archivo);
  if (img == null) {
    println("no encuentro " + archivo);
    exit();
    return;
  }
  img.loadPixels();
  int w = img.width, h = img.height;

  // 1) el histograma de la imagen completa
  double[] hist = new double[256];
  for (int i = 0; i < img.pixels.length; i++)
    hist[(int) brightness(img.pixels[i])]++;

  // 2) el campo reducido a 200×200 (para la DCT, rápido)
  int n = 200;
  double[][] vr = new double[n][n];
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      int sx = (int) (x * (float) w / n);
      int sy = (int) (y * (float) h / n);
      vr[x][y] = brightness(img.pixels[sy * w + sx]);
    }

  campo = new Campo(vr);

  // complejidad = H histograma / log2(256) = H / 8
  double complejidad = campo.entropia(hist) / 8.0;

  // orden = 1 - H espectral / Hmax, con Hmax = log2(200² - 1)
  double[][] E = campo.espectro();
  double Hmax = Math.log(n * n - 1) / Math.log(2);
  double orden = 1 - campo.entropia(E) / Hmax;

  println(archivo + ":");
  println("  orden       = " + String.format("%.3f", orden));
  println("  complejidad = " + String.format("%.3f", complejidad));

  exit();
}
