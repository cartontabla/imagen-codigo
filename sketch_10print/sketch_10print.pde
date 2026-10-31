int spacing = 20;

size(395, 395);
background(52,128,192);
strokeWeight(6);
strokeCap(ROUND);
noLoop();                       // dibuja una sola vez
stroke(255);

for (int y = 0; y < height; y += spacing) {
  for (int x = 0; x < width; x += spacing) {
    if (random(1) < 0.5) {
      line(x, y, x + 0.7 * spacing, y + 0.7 * spacing);   // barra \
    } else {
      line(x, y + 0.7 * spacing, x + 0.7 * spacing, y);   // barra /
    }
  }
}
save("10print.png");
