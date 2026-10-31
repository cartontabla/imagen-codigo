// la diana como clase: lo virtual (la clase) y lo actual (las instancias)
class Diana {
  float cx, cy;
  float[] radios;
  color[] colores;

  Diana(float cx, float cy) {
    this.cx = cx;
    this.cy = cy;
    radios = new float[]{180, 140, 100, 60, 20};
    colores = new color[]{
      color(205, 35, 35), color(255), color(240, 200, 30),
      color(30, 60, 180), color(205, 35, 35)
    };
  }

  void dibuja() {
    for (int i = 0; i < radios.length; i++) {
      fill(colores[i]);
      ellipse(cx, cy, radios[i] * 2, radios[i] * 2);
    }
  }
}

Diana estable, inestable;

void setup() {
  size(400, 400);
  background(255);
  noStroke();

  estable = new Diana(200, 200);    // lo actual: centrada, estable
  estable.dibuja();
  save("estable.png");

  background(255);
  inestable = new Diana(320, 320);  // lo actual: desplazada, inestable
  inestable.dibuja();
  save("inestable.png");
}
