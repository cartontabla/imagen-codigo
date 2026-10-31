import gab.opencv.*;
import java.awt.Rectangle;

// sketch_equilibrio05: las masas de una foto, con OpenCV.
// Lo mismo que equilibrio04, pero la segmentación la hace
// la librería OpenCV (findContours) en vez del flood fill propio.

PImage img;
OpenCV opencv;

void setup() {
  size(400, 400);
  img = loadImage("foto.jpg");
  img.resize(200, 200);

  opencv = new OpenCV(this, img);
  opencv.gray();
  opencv.invert();               // las masas oscuras: las figuras (gafas, pelo, sombras)
  opencv.threshold(128);
  ArrayList<Contour> contours = opencv.findContours();

  // dibujar la imagen
  image(img, 0, 0, 400, 400);

  // centro de cada masa (rojo) y media ponderada por el area
  stroke(255, 0, 0);
  noFill();
  double cx = 0, cy = 0, total = 0;
  int n = 0;
  for (Contour c : contours) {
    double area = c.area();
    if (area < 500) continue;    // ignorar las manchas pequeñas (ruido, textura)
    Rectangle r = c.getBoundingBox();
    float px = map(r.x + r.width / 2.0f, 0, img.width, 0, 400);
    float py = map(r.y + r.height / 2.0f, 0, img.height, 0, 400);
    ellipse(px, py, 12, 12);
    cx += px * area;
    cy += py * area;
    total += area;
    n++;
  }

  // centro de masa global (azul)
  stroke(0, 0, 255);
  ellipse((float) (cx / total), (float) (cy / total), 18, 18);

  println("masas: " + n);
  println("centro de masa: " + (cx / total) + ", " + (cy / total));
  save("equilibrio05.png");
}
