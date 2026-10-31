// proporcion03: el ángulo áureo reparte los puntos (la filotaxis)
size(400, 400);
noLoop();
background(255);
noStroke();
fill(0);

float phi = (1 + sqrt(5)) / 2;
float angulo = TWO_PI / (phi * phi);   // el ángulo áureo ≈ 137,5°
int   n = 900;                          // cuántas semillas
float c = 6;                            // cuánto crece el radio con cada una

for (int i = 0; i < n; i++) {
  float r = c * sqrt(i);                // el radio crece con la raíz
  float a = i * angulo;                 // cada semilla gira el ángulo áureo
  float x = width / 2 + r * cos(a);
  float y = height / 2 + r * sin(a);
  ellipse(x, y, 4.5, 4.5);
}
save("angaureo.png");
