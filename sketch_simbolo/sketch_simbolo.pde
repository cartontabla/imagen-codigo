// sketch_simbolo
// Símbolo: convención. ♀ y ♂ significan por acuerdo.
// Fondo blanco, figura negra.

void setup() {
  size(400, 400);
  noLoop();
  background(255);
  noStroke();
  fill(0);

  // ♀ femenino (izquierda): círculo + cruz (gruesa)
  pushMatrix();
  translate(0, 50);             // centro del símbolo
  ellipse(120, 110, 90, 90);               // círculo
  rect(111, 150, 18, 90);                  // asta de la cruz
  rect(70, 190, 100, 18);                  // brazo de la cruz

  // ♂ masculino (derecha): círculo + flecha (gruesa)
  ellipse(290, 130, 90, 90);               // círculo
  stroke(0);
  strokeWeight(16);
  line(320, 95, 350, 60);                  // asta de la flecha
  noStroke();
  triangle(366, 41, 360, 76, 333, 52);     // punta de la flecha
  popMatrix();

  save("simbolo.png");
}
