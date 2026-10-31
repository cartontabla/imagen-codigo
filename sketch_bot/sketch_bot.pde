// sketch_bot
// Bots: circunferencias blancas (sin relleno) con su dirección.
// Se mueven despacio y, cuando se tocan, controlan la dirección (se repelen)
// y el radio se colorea en rojo mientras dura el contacto.
// Guarda b0.png, b1.png, ... cada 2 segundos, hasta pulsar 'q'.

Bot[] bots;
int contador = 0;      // número de la imagen guardada
int ultimo = 0;        // instante del último guardado

void setup() {
  size(400, 400);
  bots = new Bot[6];
  for (int i = 0; i < bots.length; i++)
    bots[i] = new Bot(random(35, width - 35), random(35, height - 35), 35);
}

void draw() {
  background(0);

  for (Bot b : bots) b.mover();

  for (int i = 0; i < bots.length; i++)
    for (int j = i + 1; j < bots.length; j++)
      bots[i].intersectar(bots[j]);

  for (Bot b : bots) b.dibujar();

  // guardar cada 2 segundos
  if (millis() - ultimo > 2000) {
    ultimo = millis();
    save("b" + contador + ".png");
    contador++;
  }
}

void keyPressed() {
  if (key == 'q' || key == 'Q') exit();   // para al teclear q
}
