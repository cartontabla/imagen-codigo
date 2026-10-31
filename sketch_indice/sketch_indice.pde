// sketch_indice
// Índice: conexión. El sombrero indica a quien lo lleva.
// Fondo blanco, figura negra.

void setup() {
  size(400, 400);
  noLoop();
  background(255);
  noStroke();
  fill(0);

  // sombrero femenino (izquierda): pamela con flor
  ellipse(100, 260, 180, 40);              // ala ancha
  arc(100, 215, 100, 100, PI, TWO_PI);     // copa (cúpula)
  ellipse(140, 195, 14, 14);               // flor: centro
  ellipse(140, 181, 11, 11);               // pétalo
  ellipse(154, 195, 11, 11);               // pétalo
  ellipse(126, 195, 11, 11);               // pétalo
  ellipse(140, 209, 11, 11);               // pétalo

  // sombrero masculino (derecha): sombrero de copa
  rect(255, 135, 90, 140);                 // copa alta
  rect(237, 275, 126, 16);                 // ala

  save("indice.png");
}
