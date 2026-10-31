size(400, 400);

for (int i = 0; i < 24; i++) {
  float x0 = random(0, 400);
  float y0 = random(0, 400);
  float x1 = random(0, 400);
  float y1 = random(0, 400);
  float x2 = random(0, 400);
  float y2 = random(0, 400);
  float x3 = random(0, 400);
  float y3 = random(0, 400);

  background(200);
  for (float t = 0; t <= 1; t += 0.001) {
    float u = 1 - t;                          // el complemento de t
    float b0 = u*u*u;                         // (1-t)^3
    float b1 = 3*u*u*t;                       // 3(1-t)^2 t
    float b2 = 3*u*t*t;                       // 3(1-t) t^2
    float b3 = t*t*t;                         // t^3

    float x = b0*x0 + b1*x1 + b2*x2 + b3*x3;
    float y = b0*y0 + b1*y1 + b2*y2 + b3*y3;

    stroke(255 * t);
    strokeWeight(2);
    point(x, y);
  }
  save("curdot" + (i+1) + ".png");
}
