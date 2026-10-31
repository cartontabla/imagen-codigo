size(400, 400);

color[] paleta = {
  color(114, 79, 66), color(194, 142, 124), color(91, 120, 154),
  color(91, 108, 64), color(131, 127, 173), color(98, 189, 170),
  color(223, 122, 49), color(68, 88, 166), color(195, 79, 94),
  color(93, 60, 105), color(156, 186, 59), color(229, 162, 44),
  color(38, 62, 146), color(61, 146, 68), color(177, 53, 57),
  color(235, 199, 26), color(190, 79, 146), color(1, 135, 165),
  color(240, 241, 236), color(202, 203, 203), color(162, 164, 164),
  color(121, 121, 120), color(83, 85, 85), color(51, 51, 50)
};

int lado = 400;
PGraphics c = createGraphics(lado, lado);   // nace transparente
c.beginDraw();
c.clear();                                  // asegura el fondo transparente

int n = 500;
c.noFill();

for (int j = 0; j < n; j++) {
  color col = paleta[int(random(paleta.length))];

  c.stroke(col, random(80, 220));
  c.strokeWeight(random(4, 12));

  float x = random(lado);
  float y = random(lado);

  if (j % 2 == 0) {
    // líneas más largas para aumentar la cobertura
    float angulo = random(TWO_PI);
    float longitud = random(80, 250);

    c.line(
      x, y,
      x + cos(angulo) * longitud,
      y + sin(angulo) * longitud
    );
  } else {
    // arcos más amplios
    float r = random(50, 180);
    float inicio = random(TWO_PI);
    float barrido = random(PI / 2, TWO_PI);

    c.arc(x, y, 2 * r, 2 * r,
          inicio, inicio + barrido);
  }
}

c.endDraw();
image(c, 0, 0);        // lo muestra en la ventana
c.save("suplin.png");  // lo guarda con fondo transparente
