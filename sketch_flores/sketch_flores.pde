// sketch_flores
// Superposición. Flores al estilo de Warhol: color y posición al azar,
// y un grado de solape controlable.

int   columnas = 3;       // flores por fila
int   filas    = 3;       // flores por columna
float radio    = 130;     // radio de la flor (los pétalos llegan al borde)
float superpos = 0.15;    // 0 = tangentes, 0.9 = casi encima
float desvio   = 45;      // descuadre aleatorio de cada flor
float giro     = 0.6;     // giro aleatorio máximo (radianes)

color[] paleta  = {#E4002B, #FF7A00, #F2C200, #E5007E};
color   fondo   = #0B6E8A;
color   hierbaA = #0A5E76;
color   hierbaB = #14879E;

void setup() {
  size(760, 760);
  pixelDensity(1);
  randomSeed(7);          // reproducible
  noLoop();
}

void draw() {
  background(fondo);
  hierba();

  // el paso sale del solape, sobre el tamaño real de la flor:
  // con superpos = 0 quedan tangentes, con 0.5 se solapan la mitad
  float paso = 2 * radio * (1 - superpos);
  for (int j = 0; j < filas; j++) {
    for (int i = 0; i < columnas; i++) {
      float x = radio + i * paso + random(-desvio, desvio);
      float y = radio + j * paso + random(-desvio, desvio);
      flor(x, y, radio, paleta[int(random(paleta.length))]);
    }
  }

  save("flores.png");
}

// una flor: de tres a cinco pétalos alrededor de un centro más oscuro.
void flor(float x, float y, float r, color c) {
  noStroke();
  fill(c);
  int   petalos = int(random(3, 6));     // se sortea UNA vez, antes del bucle
  float rp      = r * 0.62;              // radio del pétalo
  float dist    = r * 0.38;              // a qué distancia va del centro
  float a0      = random(-giro, giro);   // el giro que la descoloca
  for (int k = 0; k < petalos; k++) {
    float a = a0 + k * TWO_PI / petalos; // reparto según cuántos haya
    ellipse(x + cos(a) * dist, y + sin(a) * dist, 2 * rp, 2 * rp);
  }
  fill(red(c) * 0.45, green(c) * 0.45, blue(c) * 0.45);
  ellipse(x, y, r * 0.4, r * 0.4);
}

// el fondo de hierba: trazos cortos y finos
void hierba() {
  strokeWeight(2);
  for (int i = 0; i < 3000; i++) {
    float x = random(width);
    float y = random(height);
    stroke(random(1) < 0.5 ? hierbaA : hierbaB);
    line(x, y, x + random(-10, 10), y - random(12, 45));
  }
}
