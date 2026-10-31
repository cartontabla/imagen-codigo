// proporcion02: los cuadrados de Fibonacci y la espiral
size(400, 300);
background(255);
noLoop();
stroke(0);

int n = 8;
int[] fib = new int[n];
fib[0] = 1; fib[1] = 1;
for (int i = 2; i < n; i++) fib[i] = fib[i - 1] + fib[i - 2];

// el rectángulo crece: cada cuadrado se añade a un lado
float L = 0, T = 0, R = 1, B = 1;   // tras el primer cuadrado 1x1
float[] xs = new float[n], ys = new float[n], ss = new float[n];
xs[0] = 0; ys[0] = 0; ss[0] = 1;
int dir = 0;                          // 0 este, 1 sur, 2 oeste, 3 norte

for (int i = 1; i < n; i++) {
  int s = fib[i];
  if (dir == 0)      { xs[i] = R; ys[i] = T; R += s; }          // este
  else if (dir == 1) { xs[i] = L; ys[i] = B; B += s; }          // sur
  else if (dir == 2) { xs[i] = L - s; ys[i] = T; L -= s; }      // oeste
  else               { xs[i] = L; ys[i] = T - s; T -= s; }      // norte
  ss[i] = s;
  dir = (dir + 1) % 4;
}

// escalar y centrar en el lienzo
float esc = 380 / (R - L);
float ox  = (width  - (R - L) * esc) / 2 - L * esc;
float oy  = (height - (B - T) * esc) / 2 - T * esc;

for (int i = 0; i < n; i++) {
  float x = ox + xs[i] * esc;
  float y = oy + ys[i] * esc;
  float s = ss[i] * esc;

  rect(x, y, s, s);

  if (i % 2 == 0)          // cuadrado par: arco centrado arriba-izquierda
    arc(x, y, 2 * s, 2 * s, 0, HALF_PI);
  else                     // cuadrado impar: arco centrado arriba-derecha
    arc(x + s, y, 2 * s, 2 * s, HALF_PI, PI);
}
save("fibonacci.png");
