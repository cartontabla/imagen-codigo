// sketch_collage
// Fotomontaje al estilo de las vanguardias rusas: periódico de fondo,
// barra diagonal roja, círculo negro, recortes de animales y tipografía
// grande girada. Los recortes llevan transparencia en el alfa.

PImage periodico;
PImage[] animales;
PFont fuente;
int    N = 8;

color ROJO  = #C81014;
color NEGRO = #111111;
color CREMA = #EEE8D8;

void setup() {
  size(800, 1000);
  pixelDensity(1);
  randomSeed(3);
  noLoop();

  periodico = loadImage("periodico.jpg");
  animales  = new PImage[N];
  for (int i = 0; i < N; i++) {
    animales[i] = loadImage("animal" + nf(i + 1, 2) + ".png");
  }
  fuente = createFont("SansSerif", 120, true);
}

void draw() {
  // 1. El periódico, apagado bajo un velo crema
  image(periodico, 0, 0, width, height);
  noStroke();
  fill(CREMA, 200);
  rect(0, 0, width, height);

  // 2. El gesto: la barra diagonal roja con su filo negro
  pushMatrix();
  translate(width * 0.5, height * 0.5);
  rotate(-0.38);
  fill(ROJO);
  rect(-width, -70, width * 2, 140);
  fill(NEGRO);
  rect(-width, 74, width * 2, 22);
  popMatrix();

  // 3. El círculo negro, el contrapunto
  fill(NEGRO);
  ellipse(width * 0.80, height * 0.20, 200, 200);

  // 4. El fotomontaje: los recortes, ya con su transparencia
  coloca(animales[0], 0.10, 0.62, 0.62);   // el rinoceronte
  coloca(animales[2], 0.64, 0.74, 0.34);   // la tortuga
  coloca(animales[3], 0.60, 0.11, 0.34);   // el ave

  // 5. La tipografía, girada
  pushMatrix();
  translate(60, height * 0.90);
  rotate(-0.06);
  textFont(fuente);
  textSize(104);
  textAlign(LEFT, BASELINE);
  fill(NEGRO);
  text("HAZLO", 5, 5);
  fill(ROJO);
  text("HAZLO", 0, 0);
  popMatrix();

  save("collage.png");
}

// coloca una imagen con transparencia, centrada en una fracción del lienzo
void coloca(PImage im, float fx, float fy, float ancho) {
  if (im == null) return;
  float w = width * ancho;
  float h = w * im.height / im.width;
  image(im, width * fx - w / 2, height * fy - h / 2, w, h);
}
