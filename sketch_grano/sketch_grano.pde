size(400, 400);
background(255);
loadPixels();
for (int i = 0; i < pixels.length; i++) {
  float g = random(255);
  pixels[i] = color(g);
}
updatePixels();
save("grano.png");
