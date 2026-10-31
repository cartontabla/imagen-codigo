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

      float[] p = parametros(e);          // parámetros generados una sola vez
      beginShape();
      for (PVector v : base) {
        PVector t = aplicar(v.x, v.y, e, p);
        vertex(t.x, t.y);
      }
      endShape(CLOSE);

      save("var_" + figuras[f] + "_" + estados[e] + ".png");
    }
  }
}

// figura elemental, centrada en el origen, dentro de [-60, 60]
PVector[] figura(int f) {
  if (f == 0) {              // círculo
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
  if (f == 2) {              // triángulo equilátero
    return new PVector[] {
      new PVector(0, -69), new PVector(-60, 35), new PVector(60, 35)
    };
  }
  // garabato: polígono irregular, sin ley
  PVector[] v = new PVector[24];
  for (int i = 0; i < 24; i++) {
    float a = TWO_PI * i / 24;
    float r = random(25, 60);
    v[i] = new PVector(r * cos(a), r * sin(a));
  }
  return v;
}

// parámetros del estado e (generados una sola vez por imagen)
float[] parametros(int e) {
  if (e == 1) return new float[]{ random(TWO_PI) };
  if (e == 2) return new float[]{ random(PI) };
  if (e == 3) return new float[]{ random(0.6, 1.8) };
  if (e == 4) return new float[]{ random(0.5, 1.6), random(0.5, 1.6), random(-0.5, 0.5) };
  if (e == 5) return new float[]{ random(-0.003, 0.003), random(-0.003, 0.003) };
  return new float[]{};
}

// aplica el estado e con los parámetros p al punto (x, y), centrado en (200, 200)
PVector aplicar(float x, float y, int e, float[] p) {
  float x2 = x, y2 = y;
  if (e == 1) {                          // rotación
    float a = p[0];
    x2 = x * cos(a) - y * sin(a);
    y2 = x * sin(a) + y * cos(a);
  } else if (e == 2) {                   // reflexión sobre un eje al azar
    float a = p[0];
    x2 = x * cos(2 * a) + y * sin(2 * a);
    y2 = x * sin(2 * a) - y * cos(2 * a);
  } else if (e == 3) {                   // escala uniforme (similitud)
    float s = p[0];
    x2 = x * s; y2 = y * s;
  } else if (e == 4) {                   // afín: estirar + cizallar
    float sx = p[0], sy = p[1], sh = p[2];
    x2 = sx * x + sh * y;
    y2 = sy * y;
  } else if (e == 5) {                   // proyectiva: perspectiva suave
    float g = p[0], h = p[1];
    float w = 1 + g * x + h * y;
    x2 = x / w; y2 = y / w;
  }
  return new PVector(x2 + 200, y2 + 200);
}
