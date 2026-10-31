import java.util.ArrayList;

// sketch_equilibrio04: las masas como blobs.
// Una composición con tres masas: el código las segmenta (blobs),
// calcula el centro de masa de cada una y el de toda la imagen.

Campo campo;

void setup() {
  size(400, 400);
  int n = 400;
  double[][] v = new double[n][n];
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++)
      v[x][y] = mancha(x, y, 120, 240, 80, 110, 255)   // la masa grande
              + mancha(x, y, 300, 140, 50, 50, 200)    // la mediana
              + mancha(x, y, 300, 340, 30, 30, 180);   // la pequeña

  campo = new Campo(v);
  ArrayList<Blob> bs = campo.blobs(128);   // las masas: brillo > 128

  // dibujar el campo de pesos
  background(0);
  for (int y = 0; y < n; y++)
    for (int x = 0; x < n; x++) {
      stroke((float) v[x][y]);
      point(x, y);
    }

  // el centro de masa de cada masa (rojo)
  stroke(255, 0, 0);
  noFill();
  for (Blob b : bs) {
    ellipse((float) b.cx, (float) b.cy, 12, 12);
  }

  // el centro de masa de la imagen: media ponderada de los blobs (azul)
  double[] c = campo.centroide(bs);
  stroke(0, 0, 255);
  ellipse((float) c[0], (float) c[1], 18, 18);

  println("masas: " + bs.size());
  println("centro de masa: " + c[0] + ", " + c[1]);
  save("equilibrio04.png");
}

// una masa: una mancha elíptica de brillo dado
double mancha(double x, double y, double cx, double cy, double rx, double ry, double brillo) {
  double nx = (x - cx) / rx, ny = (y - cy) / ry;
  return Math.sqrt(nx * nx + ny * ny) < 1 ? brillo : 0;
}

class Blob {
  double cx, cy;   // centro de masa
  double peso;     // peso (suma de brillos)
  int area;        // número de píxeles
}

class Campo {
  int w, h;
  double[][] v;

  Campo(double[][] valores) {
    v = valores;
    w = valores.length;
    h = valores[0].length;
  }

  // las masas: regiones conexas por encima del umbral (flood fill)
  ArrayList<Blob> blobs(double umbral) {
    int[][] etiqueta = new int[w][h];
    ArrayList<Blob> lista = new ArrayList<Blob>();
    int[] dx = { 1, -1, 0, 0 };
    int[] dy = { 0, 0, 1, -1 };
    int[] pila = new int[w * h * 2];

    for (int y = 0; y < h; y++)
      for (int x = 0; x < w; x++)
        if (v[x][y] > umbral && etiqueta[x][y] == 0) {
          Blob b = new Blob();
          double sx = 0, sy = 0, sp = 0;
          int area = 0, top = 0;
          pila[top++] = x;
          pila[top++] = y;
          etiqueta[x][y] = 1;
          while (top > 0) {
            int py = pila[--top];
            int px = pila[--top];
            double p = v[px][py];
            sx += px * p; sy += py * p; sp += p; area++;
            for (int k = 0; k < 4; k++) {
              int nx = px + dx[k], ny = py + dy[k];
              if (nx >= 0 && nx < w && ny >= 0 && ny < h &&
                  v[nx][ny] > umbral && etiqueta[nx][ny] == 0) {
                etiqueta[nx][ny] = 1;
                pila[top++] = nx;
                pila[top++] = ny;
              }
            }
          }
          b.cx = sx / sp;
          b.cy = sy / sp;
          b.peso = sp;
          b.area = area;
          lista.add(b);
        }
    return lista;
  }

  // el centro de masa de las masas: media ponderada de sus centroides
  double[] centroide(ArrayList<Blob> bs) {
    double cx = 0, cy = 0, total = 0;
    for (Blob b : bs) {
      cx += b.peso * b.cx;
      cy += b.peso * b.cy;
      total += b.peso;
    }
    return new double[]{ cx / total, cy / total };
  }
}
