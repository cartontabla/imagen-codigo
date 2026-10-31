// sketch_proporcion
// La proporción reparte la superficie: cinco razones, cinco imágenes.
// pr1 1:1 (el centro), pr2 1:2 (el tercio), pr3 2:3, pr4 3:4,
// pr5 1:phi (el punto áureo).

size(400, 400);
noLoop();
strokeWeight(2);

float phi = (1 + sqrt(5)) / 2;
float[][] razones = {{1, 1}, {1, 2}, {2, 3}, {3, 4}, {1, phi}};
String[] nombres = {"pr1", "pr2", "pr3", "pr4", "pr5"};

for (int k = 0; k < razones.length; k++) {
  background(255);
  float a = razones[k][0];
  float b = razones[k][1];

  stroke(0);
  fill(255);
  rect(0, 0, width, height);           // la superficie cuadrada

  float px = width  * a / (a + b);     // el corte, en x
  float py = height * a / (a + b);     // y en y

  line(px, 0, px, height);
  line(0, py, width, py);

  fill(0);
  ellipse(px, py, 14, 14);               // el punto de interés

  save(nombres[k] + ".png");
}
