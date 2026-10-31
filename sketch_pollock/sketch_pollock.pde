// sketch_pollock
// Goteo y trazo, ambos irregulares: el azar solicitado de Jackson Pollock.
// Los trazos nacen de una rejilla con temblor, así cubren todo el lienzo.

color[] paleta = {#141414, #F2EEE2, #A8A8A0, #C02828, #2848A0, #C8A028, #2E7A46, #C87028};
color   fondo  = #D8D0BC;    // el lienzo crudo, sin imprimar

void setup() {
  size(700, 900);
  pixelDensity(1);
  randomSeed(7);             // el azar fijado: el "controlo el flujo" de Pollock
  noLoop();
}

void draw() {
  background(fondo);
  noFill();

  // los trazos, en rejilla con temblor: llegan a todo el lienzo
  int cols = 19, filas = 50;
  for (int j = 0; j < filas; j++) {
    for (int i = 0; i < cols; i++) {
      float x = (i + 0.5) * width  / cols + random(-55, 55);
      float y = (j + 0.5) * height / filas + random(-55, 55);
      trazo(x, y, paleta[int(random(paleta.length))]);
    }
  }
  // los goteos, repartidos también por todo el lienzo
  for (int i = 0; i < 732; i++) {
    goteo(random(width), random(height * 0.85), paleta[int(random(paleta.length))]);
  }
  save("pollock.png");
}

// el trazo: arco tendido a la horizontal, fino, con latigazo muy ocasional
void trazo(float x, float y, color c) {
  stroke(c, 200);
  strokeWeight(random(1, 2));
  float a = (random(1) < 0.5 ? 0 : PI) + random(-0.5, 0.5);   // dirección tendida
  float v = random(5, 9);              // paso
  int   n = int(random(70, 170));      // longitud
  float giro = random(-0.6, 0.6);      // poco giro: el arco no llega a vertical
  float dg = giro / n;                 // giro por paso
  beginShape();
  for (int k = 0; k < n; k++) {
    vertex(x, y);
    a += dg + random(-0.02, 0.02);     // la curva + la irregularidad
    if (random(1) < 0.003) a += random(-0.5, 0.5);   // el latigazo, raro y corto
    x += cos(a) * v;
    y += sin(a) * v;
    if (x < -60 || x > width + 60 || y < -60 || y > height + 60) break;
  }
  endShape();
}

// el goteo: una vertical que cae, se detiene y deja la gota
void goteo(float x, float y, color c) {
  stroke(c, 150);
  strokeWeight(1);
  float largo = random(0, height);   // el recorrido, en PÍXELES
  int   n     = int(largo / 5);             // pasos de 5 px
  beginShape();
  for (int k = 0; k < n && y < height; k++) {
    vertex(x, y);
    x += random(-1.0, 1.0);                 // serpentea
    y += 5;                                 // cae
  }
  endShape();
  if (y < height) {                         // la gota, donde se paró el hilo
    noStroke();
    fill(c, 170);
    ellipse(x, y, random(4, 10), random(6, 12));
    noFill();                               // que el relleno no pase al siguiente
    stroke(c, 150);                         // y se devuelva el trazo
  }
}
