size(400, 400);
colorMode(HSB, 360, 100, 100);
noStroke();
for (int x = 0; x < width; x++) {
  float matiz = map(x, 0, width, 0, 360);
  fill(matiz, 100, 100);
  rect(x, 0, 1, height);
}
save("matiz.png");
