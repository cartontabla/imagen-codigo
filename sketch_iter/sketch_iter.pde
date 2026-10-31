// sketch_iter
// Iteración: la figura repetida en posiciones sucesivas
// (Duchamp, "Mujer bajando la escalera").

void setup() {
  size(800, 600);
  noLoop();
  background(245);
  noStroke();
  fill(40);

  for (int i = 0; i < 8; i++)
    cuerpoCubista(150 + i * 70, 130 + i * 42);   // cada copia desciende

  save("iter.png");
}

// Cuerpo cubista: signos primarios compuestos en un todo.
void cuerpoCubista(float cx, float cy) {
  ellipse(cx - 10, cy, 60, 70);                // cabeza (frente)
  triangle(cx + 20, cy - 35, cx + 65, cy, cx + 20, cy + 35);  // perfil
  rect(cx - 45, cy + 45, 55, 85);              // torso (fragmento)
  rect(cx + 15, cy + 50, 45, 75);              // torso (fragmento)
  rect(cx - 80, cy + 50, 22, 85);              // brazo
  rect(cx + 70, cy + 45, 22, 90);              // brazo
  rect(cx - 40, cy + 135, 28, 110);            // pierna
  rect(cx + 10, cy + 135, 28, 110);            // pierna
}
