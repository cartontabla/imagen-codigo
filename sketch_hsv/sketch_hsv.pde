size(400, 310);
background(255);
colorMode(HSB, 360, 100, 100);
noStroke();

// matiz: qué color (de 0 a 360 grados)
for (int x = 0; x < width; x++) {
  float matiz = map(x, 0, width, 0, 360);
  fill(matiz, 100, 100);
  rect(x, 0, 1, 100);
}

// saturación: cuánto color (del blanco al color puro)
for (int x = 0; x < width; x++) {
  float saturacion = map(x, 0, width, 0, 100);
  fill(0, saturacion, 100);
  rect(x, 105, 1, 100);
}

// brillo: cuánta luz (del negro al color)
for (int x = 0; x < width; x++) {
  float brillo = map(x, 0, width, 0, 100);
  fill(0, 100, brillo);
  rect(x, 210, 1, 100);
}

save("hsv.png");
