// sketch_warhol
// Genera 24 imagenes: la silla sobre los 24 colores del colorchecker,
// con la tinta (el negro) en un color distinto del fondo, complementario si se puede.
//
// Necesita en la carpeta data/: chair_transp_suave.png

PImage silla;

// los 24 colores del colorchecker (X-Rite i1Pro 2, D50, 2o)
color[] cc = {
  color(114, 79, 66),  color(194, 142, 124), color(91, 120, 154), color(91, 108, 64),
  color(131, 127, 173), color(98, 189, 170),
  color(223, 122, 49),  color(68, 88, 166),   color(195, 79, 94),  color(93, 60, 105),
  color(156, 186, 59),  color(229, 162, 44),
  color(38, 62, 146),   color(61, 146, 68),   color(177, 53, 57),  color(235, 199, 26),
  color(190, 79, 146),  color(1, 135, 165),
  color(240, 241, 236), color(202, 203, 203), color(162, 164, 164), color(121, 121, 120),
  color(83, 85, 85),    color(51, 51, 50)
};

void setup() {
  size(640, 506);
  silla = loadImage("chair_transp_suave.png");
  randomSeed(1);          // fija la serie, para que sea reproducible
  noLoop();
}

void draw() {
  for (int i = 0; i < cc.length; i++) {
    background(cc[i]);                                   // el fondo: un color del colorchecker
    image(tinta(silla, colorTinta(cc[i])), 0, 0);        // la silla: el negro, en otro color
    save("warhol_" + nf(i + 1, 2) + ".png");
  }
}

// la silla recoloreada: conserva la transparencia y cambia el negro por un color
PImage tinta(PImage img, color c) {
  PImage out = img.get();
  out.loadPixels();
  for (int i = 0; i < out.pixels.length; i++) {
    out.pixels[i] = color(red(c), green(c), blue(c), alpha(out.pixels[i]));
  }
  out.updatePixels();
  return out;
}

// color de la tinta: complementario del fondo, con algo de azar
color colorTinta(color fondo) {
  colorMode(HSB, 360, 100, 100);
  float hf = hue(fondo);
  float sf = saturation(fondo);
  // si el fondo es gris no hay complementario: tono al azar
  float h = (sf < 12) ? random(360) : (hf + 180 + random(-45, 45) + 360) % 360;
  color c = color(h, random(60, 100), random(70, 100));
  colorMode(RGB, 255);
  return c;
}
