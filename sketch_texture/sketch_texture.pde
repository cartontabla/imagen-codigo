size(400, 400);
background(255);
background(255);
noStroke();
fill(0);
for (int y = 0; y < height; y += 10) {
  for (int x = 0; x < width; x += 10) {
    ellipse(x, y, 6, 6);
  }
}
save("texture.png");
