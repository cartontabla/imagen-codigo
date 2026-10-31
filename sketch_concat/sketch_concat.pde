// sketch_concat
// Concatenación: signos primarios yuxtapuestos, sin componer.

void setup() {
  size(800, 600);
  noLoop();
  background(245);
  noStroke();
  fill(40);

  // círculo, rectángulos y triángulo sueltos (sin formar un todo)
  ellipse(70, 300, 70, 70);
  rect(170, 260, 55, 85);
  triangle(270, 300, 330, 230, 330, 370);
  rect(380, 260, 22, 90);
  rect(440, 260, 22, 90);
  rect(500, 330, 28, 110);
  rect(560, 330, 28, 110);

  save("concat.png");
}
