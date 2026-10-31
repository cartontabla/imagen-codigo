size(400, 400);
fill(255, 0, 0);
noStroke();
  
for (int k = 0; k < 6; k++) {
  int n = 2 * k + 1;        // genera 1, 3, 5, 7, 9, 11

  background(200);
  beginShape();
  for (int i = 0; i < n; i++) {
    float angulo = TWO_PI * i * 2 / n;   // paso = 2
    vertex(200 + 100 * cos(angulo), 200 + 100 * sin(angulo));
  }
  endShape(CLOSE);

  save("estrella" + n + ".png");
}
