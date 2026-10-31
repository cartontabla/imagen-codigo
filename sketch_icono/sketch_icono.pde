// sketch_icono
// Icono: semejanza. La figura se parece a una mujer / un hombre
// (señal de baño). Fondo blanco, figura negra.

void setup() {
  size(400, 400);
  noLoop();
  background(255);
  noStroke();
  fill(0);

  // mujer (izquierda): cabeza + vestido
  ellipse(120, 90, 70, 70);
  quad(85, 125, 155, 125, 200, 370, 40, 370);

  // hombre (derecha): cabeza + torso + piernas
  ellipse(290, 90, 70, 70);
  rect(255, 125, 70, 100);
  rect(255, 225, 30, 145);
  rect(295, 225, 30, 145);

  save("icono.png");
}
