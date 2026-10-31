// sketch_variacion
// Genera 24 imagenes: 4 figuras x 6 estados.
// Estados: 0 original, 1 rotacion, 2 reflexion, 3 escala (similitud),
//          4 afin, 5 proyectiva.
// Lienzo 400x400, fondo 200, figura roja sin contorno.
// El punto rojo de referencia (arriba de la figura) se transforma con ella
// y hace visibles la rotacion y la reflexion en figuras simetricas.

String[] figuras = {"circulo", "cuadrado", "triangulo", "garabato"};
String[] estados = {"original", "rotacion", "reflexion", "escala", "afin", "proyectiva"};

void setup() {
  size(400, 400);
  noLoop();
  randomSeed(1);          // reproducible
}

void draw() {
  for (int f = 0; f < figuras.length; f++) {
    PVector[] base = figura(f);
    for (int e = 0; e < estados.length; e++) {
      background(200);
      noStroke();
      fill(255, 0, 0);

      float[] p = parametros(e);          // parametros generados una sola vez
      beginShape();
      for (PVector v : base) {
        PVector t = aplicar(v.x, v.y, e, p);
        vertex(t.x, t.y);
      }
      endShape(CLOSE);

      // marca de referencia: mismo punto local, transformado igual
      PVector m = aplicar(0, -85, e, p);
      ellipse(m.x, m.y, 12, 12);

      save("variacion_" + figuras[f] + "_" + estados[e] + ".png");
    }
  }
}

// figura elemental, centrada en el origen, dentro de [-60, 60]
PVector[] figura(int f) {
  if (f == 0) {              // circulo
    PVector[] v = new PVector[64];
    for (int i = 0; i < 64; i++) {
      float a = TWO_PI * i / 64;
      v[i] = new PVector(60 * cos(a), 60 * sin(a));
    }
    return v;
  }
  if (f == 1) {              // cuadrado
    return new PVector[] {
      new PVector(-60, -60), new PVector(60, -60),
      new PVector(60, 60),   new PVector(-60, 60)
    };
  }
  if (f == 2) {              // triangulo equilatero
    return new PVector[] {
      new PVector(0, -69), new PVector(-60, 35), new PVector(60, 35)
    };
  }
  // garabato: poligono irregular, sin ley
  PVector[] v = new PVector[24];
  for (int i = 0; i < 24; i++) {
    float a = TWO_PI * i / 24;
    float r = random(25, 60);
    v[i] = new PVector(r * cos(a), r * sin(a));
  }
  return v;
}

// parametros del estado e (generados una sola vez por imagen)
float[] parametros(int e) {
  if (e == 1) return new float[]{ random(TWO_PI) };                                  // angulo
  if (e == 2) return new float[]{ random(PI) };                                      // eje
  if (e == 3) return new float[]{ random(0.6, 1.8) };                                // escala
  if (e == 4) return new float[]{ random(0.5, 1.6), random(0.5, 1.6), random(-0.5, 0.5) }; // sx, sy, cizalla
  if (e == 5) return new float[]{ random(-0.003, 0.003), random(-0.003, 0.003) };    // perspectiva g, h
  return new float[]{};
}

// aplica el estado e con los parametros p al punto (x, y), centrado en (200, 200)
PVector aplicar(float x, float y, int e, float[] p) {
  float x2 = x, y2 = y;
  if (e == 1) {                        // rotacion
    float a = p[0];
    x2 = x * cos(a) - y * sin(a);
    y2 = x * sin(a) + y * cos(a);
  } else if (e == 2) {                 // reflexion sobre un eje al azar
    float a = p[0];
    x2 = x * cos(2 * a) + y * sin(2 * a);
    y2 = x * sin(2 * a) - y * cos(2 * a);
  } else if (e == 3) {                 // escala uniforme (similitud)
    float s = p[0];
    x2 = x * s; y2 = y * s;
  } else if (e == 4) {                 // afin: estirar + cizallar
    float sx = p[0], sy = p[1], sh = p[2];
    x2 = sx * x + sh * y;
    y2 = sy * y;
  } else if (e == 5) {                 // proyectiva: perspectiva suave
    float g = p[0], h = p[1];
    float w = 1 + g * x + h * y;
    x2 = x / w; y2 = y / w;
  }
  return new PVector(x2 + 200, y2 + 200);
}
