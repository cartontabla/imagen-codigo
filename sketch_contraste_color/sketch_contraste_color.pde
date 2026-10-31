// itten_color: los siete contrastes de Itten, 6 variaciones cada uno
size(400, 400);
noLoop();
noStroke();
colorMode(HSB, 360, 100, 100);

// 1. tono: rojo fijo contra un tono que barre el círculo
float[] tonos = {60, 120, 180, 240, 300, 330};
for (int i = 0; i < 6; i++) {
  fill(0, 100, 100); rect(0, 0, 200, 400);
  fill(tonos[i], 100, 100); rect(200, 0, 200, 400);
  save("1" + (i + 1) + ".png");
}

// 2. claro-oscuro: negro fijo contra un gris que sube al blanco
for (int i = 0; i < 6; i++) {
  fill(0, 0, 0); rect(0, 0, 200, 400);
  fill(0, 0, i * 20); rect(200, 0, 200, 400);
  save("2" + (i + 1) + ".png");
}

// 3. frío-cálido: azul fijo contra tonos cada vez más cálidos
float[] calidos = {180, 120, 60, 30, 0, 330};
for (int i = 0; i < 6; i++) {
  fill(210, 100, 100); rect(0, 0, 200, 400);
  fill(calidos[i], 100, 100); rect(200, 0, 200, 400);
  save("3" + (i + 1) + ".png");
}

// 4. complementarios: pares opuestos en el círculo
for (int i = 0; i < 6; i++) {
  float h = i * 60;
  fill(h, 100, 100); rect(0, 0, 200, 400);
  fill((h + 180) % 360, 100, 100); rect(200, 0, 200, 400);
  save("4" + (i + 1) + ".png");
}

// 5. simultáneo: el mismo gris sobre dos fondos distintos
for (int i = 0; i < 6; i++) {
  float h = i * 60;
  fill(h, 100, 100); rect(0, 0, 200, 400);
  fill((h + 180) % 360, 100, 100); rect(200, 0, 200, 400);
  fill(0, 0, 50);
  rect(80, 150, 40, 100);
  rect(280, 150, 40, 100);
  save("5" + (i + 1) + ".png");
}

// 6. saturación: rojo saturado contra rojos cada vez más grises
for (int i = 0; i < 6; i++) {
  fill(0, 100, 100); rect(0, 0, 200, 400);
  fill(0, 100 - i * 20, 100); rect(200, 0, 200, 400);
  save("6" + (i + 1) + ".png");
}

// 7. extensión: la proporción de área cambia
for (int i = 0; i < 6; i++) {
  int ancho = 20 + i * 60;
  fill(0, 100, 100); rect(0, 0, ancho, 400);
  fill(0, 0, 100); rect(ancho, 0, 400 - ancho, 400);
  save("7" + (i + 1) + ".png");
}
