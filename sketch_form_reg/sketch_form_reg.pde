size(400, 400);
fill(255, 0, 0);
stroke(0);
strokeWeight(2);

for (int n = 1; n < 25; n++) {          // número de lados
  background(200);
  float r = 100;       // radio

  beginShape();
  for (int i = 0; i < n; i++) {
    float angulo = TWO_PI * i / n;
    vertex(200 + r * cos(angulo), 200 + r * sin(angulo));
  }
  endShape(CLOSE);
  save("reg"+ n + ".png");
}
