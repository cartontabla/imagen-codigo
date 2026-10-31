// sketch_lewitt
// Wall Drawing #118 (Sol LeWitt, 1971):
// "Coloca cincuenta puntos al azar... todos los puntos deben unirse
// por líneas rectas." La obra es la instrucción; cada ejecución es distinta.

int n = 50;
PVector[] p;

void setup() {
  size(400, 400);
  noLoop();

  // 1) cincuenta puntos al azar, repartidos por toda la superficie
  p = new PVector[n];
  for (int i = 0; i < n; i++)
    p[i] = new PVector(random(width), random(height));

  // 2) unir cada par de puntos con una línea recta
  background(255);
  stroke(0);
  strokeWeight(0.5);
  for (int i = 0; i < n; i++)
    for (int j = i + 1; j < n; j++)
      line(p[i].x, p[i].y, p[j].x, p[j].y);

  // 3) marcar los puntos
  fill(0);
  noStroke();
  for (PVector q : p)
    ellipse(q.x, q.y, 3, 3);

  save("lewitt_118.png");
}
