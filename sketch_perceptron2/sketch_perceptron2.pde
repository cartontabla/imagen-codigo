// sketch_perceptron: la neurona aprende un horizonte.
// Su certeza no es una clasificación: es una intensidad que se vuelve luz.
// Al principio es niebla; al aprender, la niebla se afila en un horizonte.

float w1 = 0, w2 = 0, b = 0;   // pesos y sesgo
float lr = 0.01;
int celda = 6;

void setup() {
  size(400, 400);
  pixelDensity(1);
}

void draw() {
  // entrenar un ejemplo aleatorio por frame
  float x = random(width), y = random(height);
  int objetivo = (y > 0.6 * x + 120) ? 1 : -1;   // la regla oculta
  int salida = (w1 * x + w2 * y + b > 0) ? 1 : -1;
  float error = objetivo - salida;
  w1 += lr * error * x;
  w2 += lr * error * y;
  b  += lr * error;

  // verter la certeza en un degradado: abajo mar, arriba cielo, en medio luz
  noStroke();
  for (int py = 0; py < height; py += celda) {
    for (int px = 0; px < width; px += celda) {
      float s = w1 * px + w2 * py + b;           // la certeza
      float t = constrain(s / 500.0, -1, 1);
      if (t > 0) fill(lerpColor(color(255, 255, 255), color(255, 150, 60), t));
      else       fill(lerpColor(color(255, 255, 255), color(20, 45, 110), -t));
      rect(px, py, celda, celda);
    }
  }
}
