// sketch_perceptron: una neurona aprende a separar dos clases de puntos.
// La máquina no recibe la regla: la induce a partir de ejemplos (caja negra).

float w1 = 0, w2 = 0, b = 0;   // pesos y sesgo
float lr = 0.01;                // tasa de aprendizaje
PVector[] puntos;
int[] clases;                   // +1 o -1
int n = 200;
int indice = 0;

void setup() {
  size(400, 400);
  pixelDensity(1);
  puntos = new PVector[n];
  clases = new int[n];
  for (int i = 0; i < n; i++) {
    puntos[i] = new PVector(random(width), random(height));
    // la regla oculta: por encima de y = 0.7x + 80 es +1, por debajo -1
    clases[i] = (puntos[i].y > 0.7 * puntos[i].x + 80) ? 1 : -1;
  }
}

void draw() {
  background(255);
  // dibujar los puntos
  for (int i = 0; i < n; i++) {
    fill(clases[i] == 1 ? color(255, 110, 110) : color(110, 110, 255));
    noStroke();
    ellipse(puntos[i].x, puntos[i].y, 8, 8);
  }
  // entrenar un ejemplo por frame
  entrenar(puntos[indice], clases[indice]);
  indice = (indice + 1) % n;
  // dibujar la línea que separa
  if (abs(w2) > 0.0001) {
    stroke(0);
    strokeWeight(2);
    line(0, -(w1 * 0 + b) / w2, width, -(w1 * width + b) / w2);
  }
}

void entrenar(PVector p, int objetivo) {
  int salida = (w1 * p.x + w2 * p.y + b > 0) ? 1 : -1;
  float error = objetivo - salida;
  w1 += lr * error * p.x;
  w2 += lr * error * p.y;
  b  += lr * error;
}
