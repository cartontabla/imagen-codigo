// molnar: trame con dirección dominante, longitud variable y desorden leve
// Vera Molnar: una retícula que apunta, con un temblor mínimo.

float direccion = 90;    // la dirección dominante en grados (90° = vertical)
float desorden  = 2;     // la desviación máxima en grados

void setup() {
  size(400, 400);
  background(255);
  stroke(0);
  noLoop();

  int cols = 30, filas = 30;
  float pasoX = width  / (float) cols;
  float pasoY = height / (float) filas;

  for (int j = 0; j < filas; j++) {
    for (int i = 0; i < cols; i++) {
      float x = i * pasoX + pasoX / 2 + random(-2.5, 2.5);
      float y = j * pasoY + pasoY / 2 + random(-2.5, 2.5);
      float ang = radians(direccion + random(-desorden, desorden));
      float largo = random(8, 24);
      float dx = cos(ang) * largo / 2;
      float dy = sin(ang) * largo / 2;
      line(x - dx, y - dy, x + dx, y + dy);
    }
  }
  save("molnar.png");
}
