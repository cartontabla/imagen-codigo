// sketch_nebulosa
// Nebulosa: espiral gaussiana con curva suave y fusión aditiva.
// Funciones no usadas antes: randomGaussian, dist, lerp, pow, curveVertex, blendMode.

int N = 1500;
PVector[] pts = new PVector[N];

void setup() {
  size(800, 800);
  noLoop();
  background(0);
  blendMode(ADD);            // fusión aditiva (resplandor)
  noStroke();

  float cx = width / 2, cy = height / 2;
  float maxR = 360;
  float vueltas = 4;

  // estrellas: espiral logarítmica con jitter gaussiano
  for (int i = 0; i < N; i++) {
    float theta = map(i, 0, N, 0, vueltas * TWO_PI);
    float r = 2 * exp(0.2 * theta);   // espiral logarítmica r = a·e^(b·θ)
    float jitter = randomGaussian() * 18;       // dispersión gaussiana
    float rr = r + jitter;
    pts[i] = new PVector(cx + rr * cos(theta), cy + rr * sin(theta));
  }

  // trazo curvo que recorre el brazo de la espiral
  stroke(255, 200, 100, 120);
  strokeWeight(1.5);
  noFill();
  beginShape();
  for (int i = 0; i < N; i += 8)
    curveVertex(pts[i].x, pts[i].y);
  endShape();

  // estrellas: color y radio interpolados por distancia
  noStroke();
  for (int i = 0; i < N; i++) {
    float d = dist(pts[i].x, pts[i].y, cx, cy);   // distancia al centro
    float f = map(d, 0, maxR, 0, 1);              // normalizada
    color c = lerpColor(color(255, 210, 120), color(80, 90, 200), f);
    float rad = lerp(5, 1, f);
    fill(c, 40);
    ellipse(pts[i].x, pts[i].y, rad, rad);
  }

  save("nebulosa.png");
}
