size(400, 400);
background(200);
for(int i = 0; i < 400; i++) {
  float x = random(width); // posición horizontal al azar
  float y = random(height); // posición vertical al azar
  stroke(0, 100); // negro con transparencia
  strokeWeight(6);
  point(x, y);
}
