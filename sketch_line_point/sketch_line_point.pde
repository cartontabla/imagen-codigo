size(400, 400);

for(int i = 0; i < 24; i++) {
  float x0 = random(0, 400);
  float y0 = random(0, 400);
  float x1 = random(0, 400);
  float y1 = random(0, 400);
  
  background(200);
  for (float t = 0; t <= 1; t += 0.001) {
    stroke(255 * t);
    strokeWeight(2);
    point(x0 + t * (x1 - x0), y0 + t * (y1 - y0));
  }
  save("lindot" + (i+1) + ".png");
}
