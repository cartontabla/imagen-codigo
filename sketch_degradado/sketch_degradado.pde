size(400, 400);

color a = color(38, 62, 146);    // azul
color b = color(235, 199, 26);   // amarillo

for (int x = 0; x < width; x++) {
  float t = map(x, 0, width - 1, 0, 1);
  stroke(lerpColor(a, b, t));
  line(x, 0, x, height);
}

save("degradado.png");
