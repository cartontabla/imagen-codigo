size(400, 400);
noLoop();
noStroke();

float lado = 400;
float gris = 0;                       // de negro a blanco
float x = 0, y = 0;
float razon = 0.6;                    // ← la proporción

while (lado > 4) {
  fill(gris);
  rect(x, y, lado, lado);
  x += (lado - lado * razon) / 2;     // se centra el siguiente
  y += (lado - lado * razon) / 2;
  lado *= razon;
  gris += 64;                          // sube el valor
}
save("albers.png");
