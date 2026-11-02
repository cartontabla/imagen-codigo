// ==================================================
// sketch_mask — Las relaciones entre capas
// ==================================================
// Genera 6 imágenes independientes, una por variante,
// y las guarda en data/ con el nombre de lo que hacen:
//
//   superposicion.png · mascara.png · recorte.png
//   marco.png · relleno.png · fusion.png
//
// Un solo par de imágenes base (un fondo y una figura):
// solo cambia la condición que decide qué píxel se ve.
// ==================================================

PImage fondo;      // el fondo (degradado cálido)
PImage figura;     // la figura (silueta, fondo transparente)
PImage figuraM;    // la figura como máscara (blanco sobre negro)
PImage textoM;     // el texto como máscara (blanco sobre negro)
PImage circuloM;   // el círculo como máscara (blanco sobre negro)
PImage marcoBase;  // el marco (borde, interior transparente)

final int W = 400, H = 400;

void setup() {
  size(400, 400);
  pixelDensity(1);
  noLoop();

  new File(sketchPath("data")).mkdirs();

  fondo     = makeFondo();
  figura    = makeFigura(false);
  figuraM   = makeFigura(true);
  textoM    = makeTexto();
  circuloM  = makeCirculo();
  marcoBase = makeMarco();

  guardar("superposicion", superposicion());
  guardar("mascara",       mascara());
  guardar("recorte",       recorte());
  guardar("marco",         marco());
  guardar("relleno",       relleno());
  guardar("fusion",        fusion());
}

void draw() {
  background(245);
  exit();
}

// ==================================================
// Las seis variantes
// ==================================================

// 1. SUPERPOSICIÓN: una imagen sobre otra, con opacidad
PImage superposicion() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.image(fondo, 0, 0);
  g.tint(255, 150);
  g.image(figura, 0, 0);
  g.endDraw();
  return g.get();
}

// 2. MÁSCARA: el fondo se ve solo dentro de la figura
PImage mascara() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  PImage m = fondo.get();
  m.mask(figuraM);
  g.image(m, 0, 0);
  g.endDraw();
  return g.get();
}

// 3. RECORTE: el fondo se ve solo dentro de un círculo
PImage recorte() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.image(figura, 0, 0);
  PImage m = fondo.get();
  m.mask(circuloM);
  g.image(m, 0, 0);
  g.endDraw();
  return g.get();
}

// 4. MARCO: el fondo se ve dentro del marco
PImage marco() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.image(fondo, 0, 0);
  g.image(marcoBase, 0, 0);
  g.endDraw();
  return g.get();
}

// 5. RELLENO: el texto IMAGEN se rellena con el fondo
PImage relleno() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  PImage m = fondo.get();
  m.mask(textoM);
  g.image(m, 0, 0);
  g.endDraw();
  return g.get();
}

// 6. FUSIÓN: la figura multiplica al fondo
PImage fusion() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.image(fondo, 0, 0);
  g.blendMode(MULTIPLY);
  g.image(figura, 0, 0);
  g.endDraw();
  return g.get();
}

// ==================================================
// Guardar
// ==================================================

void guardar(String nombre, PImage img) {
  String ruta = "data/" + nombre + ".png";
  img.save(ruta);
  println("guardado: " + ruta);
}

// ==================================================
// Generación de las imágenes base
// ==================================================

PImage makeFondo() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  for (int i = 0; i < H; i++) {
    float t = i / (float) H;
    g.stroke(lerpColor(color(255, 120, 40), color(30, 80, 200), t));
    g.line(0, i, W, i);
  }
  g.endDraw();
  return g.get();
}

PImage makeFigura(boolean mascara) {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  if (mascara) g.background(0); else g.clear();
  g.noStroke();
  g.fill(mascara ? color(255) : color(230, 60, 60));
  g.ellipse(W / 2, H / 2, W * 0.7, H * 0.7);
  g.endDraw();
  return g.get();
}

PImage makeTexto() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.background(0);
  g.fill(255);
  g.textAlign(CENTER, CENTER);
  g.textSize(80);
  g.text("IMAGEN", W / 2, H / 2);
  g.endDraw();
  return g.get();
}

PImage makeCirculo() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.background(0);
  g.noStroke();
  g.fill(255);
  g.ellipse(W / 2, H / 2, W * 0.8, H * 0.8);
  g.endDraw();
  return g.get();
}

PImage makeMarco() {
  PGraphics g = createGraphics(W, H, JAVA2D);
  g.beginDraw();
  g.clear();
  g.noFill();
  g.stroke(20, 20, 30);
  g.strokeWeight(60);
  g.rect(0, 0, W, H);
  g.endDraw();
  return g.get();
}
