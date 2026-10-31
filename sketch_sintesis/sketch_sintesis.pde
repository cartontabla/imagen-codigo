// sketch_sintesis
// Síntesis: la letra es la regla y la imagen es el material.
// La misma imagen, con otra palabra, es otra cosa.

PImage   foto;
PGraphics molde;
PFont    fuente;

void setup() {
  size(800, 800);
  pixelDensity(1);
  noLoop();

  foto = loadImage("foto.jpg");
  foto.resize(width, height);
  fuente = createFont("SansSerif", 200, true);

  // el molde: la palabra en blanco sobre negro
  molde = createGraphics(width, height);
  molde.beginDraw();
  molde.background(0);
  molde.fill(255);
  molde.textFont(fuente);
  molde.textAlign(CENTER, CENTER);
  molde.textSize(210);
  molde.text("SÍNTESIS", width / 2, height / 2);
  molde.endDraw();

  // la imagen toma la forma del molde
  foto.mask(molde);
}

void draw() {
  background(255);
  image(foto, 0, 0, width, height);
  save("sintesis.png");
}
