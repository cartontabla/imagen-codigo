import java.util.ArrayList;

// sketch_equilibrio06: blobs jerárquicos.
// Una cascada de umbrales sobre el brillo: en cada nivel las zonas
// conexas se estrechan y los detalles aparecen dentro de las zonas
// grandes. Cada blob tiene un padre (el que lo contiene): jerarquía.

PImage img;
int K = 6;
float[] ts = new float[K];
Nivel[] niveles;

void setup() {
  size(400, 400);
  img = loadImage("foto.jpg");
  img.resize(200, 200);
  img.loadPixels();
  int w = img.width, h = img.height;

  double[][] v = new double[w][h];
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w; x++)
      v[x][y] = brightness(img.pixels[y * w + x]);

  for (int k = 0; k < K; k++) ts[k] = (k + 1) * 255.0 / (K + 1);
  niveles = new Nivel[K];
  for (int k = 0; k < K; k++) niveles[k] = analizar(v, ts[k]);

  // el padre de cada blob: el del nivel anterior que lo contiene
  for (int k = 1; k < K; k++)
    for (Blob b : niveles[k].blobs)
      b.padre = niveles[k - 1].etiqueta[b.repY][b.repX];

  // dibujar la imagen y las cajas anidadas
  image(img, 0, 0, 400, 400);
  noFill();
  for (int k = 0; k < K; k++) {
    float f = (float) k / (K - 1);
    stroke(255 * (1 - f), 60, 255 * f);   // azul (grande) -> rojo (detalle)
    strokeWeight(k == 0 ? 2 : 1);
    for (Blob b : niveles[k].blobs) {
      if (b.area < 80) continue;
      rect(map(b.x0, 0, w, 0, 400), map(b.y0, 0, h, 0, 400),
           map(b.x1 - b.x0 + 1, 0, w, 0, 400), map(b.y1 - b.y0 + 1, 0, h, 0, 400));
    }
  }

  for (int k = 0; k < K; k++) {
    print("nivel " + k + " t=" + (int) ts[k] + ":");
    for (Blob b : niveles[k].blobs) {
      if (b.area < 80) continue;
      print(" [" + (int) b.cx + "," + (int) b.cy + " p=" + b.padre + "]");
    }
    println();
  }

  save("equilibrio06.png");
}
