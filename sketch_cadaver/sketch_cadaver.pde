// sketch_cadaver
// Cadáver exquisito: tres imágenes, cada una aporta su franja.
// Arriba la cabeza, en medio el cuerpo, abajo las piernas.

PImage cabeza, cuerpo, piernas;
int tercio;

void setup() {
  size(400, 600);
  pixelDensity(1);

  cabeza  = loadImage("cabeza.png");
  cuerpo  = loadImage("cuerpo.png");
  piernas = loadImage("piernas.png");

  // las tres al mismo tamaño del lienzo, para que las franjas encajen
  cabeza.resize(width, height);
  cuerpo.resize(width, height);
  piernas.resize(width, height);

  tercio = height / 3;
  noLoop();
}

void draw() {
  background(0);

  // cada una aporta su tercio: arriba, medio, abajo
  image(cabeza.get(0, 0,          width, tercio), 0, 0);
  image(cuerpo.get(0, tercio,      width, tercio), 0, tercio);
  image(piernas.get(0, 2 * tercio, width, tercio), 0, 2 * tercio);

  save("cadaver_exquisito.png");
}
