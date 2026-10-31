// sketch_simon_est
// A partir de una imagen tipo Every Icon (32×32), calcula la iteración
// exacta (el valor binario de las celdas) y el tiempo que tardaría en
// alcanzarla, con 1 iteración = 1 segundo.
// Pulsa 's' para guardar, 'q' para salir.

import java.math.BigInteger;

PImage img;
int N = 32;
BigInteger iteracion, segundos, anyos;

void setup() {
  size(720, 420);
  img = loadImage("imagen.png");   // pon tu imagen en data/
  img.resize(N, N);
  iteracion = calcularIteracion(img);
  segundos = iteracion;                                     // 1 iteración = 1 s
  anyos = iteracion.divide(BigInteger.valueOf(31557600));   // s → años
  noLoop();
}

void draw() {
  background(255);

  // el icono
  image(img, 20, 50, 320, 320);
  noFill();
  stroke(0);
  rect(20, 50, 320, 320);

  // los resultados
  fill(0);
  textSize(16);
  text("Every Icon — iteración y tiempo", 360, 70);
  textSize(14);
  text("Iteración:  " + cientifica(iteracion), 360, 130);
  text("Segundos:   " + cientifica(segundos), 360, 170);
  text("Años:       " + cientifica(anyos), 360, 210);
  text("(1 iteración = 1 segundo)", 360, 250);
}

// valor binario de las celdas: (0,0) es el bit menos significativo
BigInteger calcularIteracion(PImage icono) {
  BigInteger n = BigInteger.ZERO;
  BigInteger dos = BigInteger.valueOf(2);
  BigInteger peso = BigInteger.ONE;
  for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++) {
      if (brightness(icono.get(j, i)) < 128)
        n = n.add(peso);
      peso = peso.multiply(dos);
    }
  return n;
}

// notación científica: "1.23 × 10^307"
String cientifica(BigInteger n) {
  String s = n.toString();
  if (s.length() <= 6) return s;
  return s.charAt(0) + "." + s.substring(1, 3) + " × 10^" + (s.length() - 1);
}

void keyPressed() {
  if (key == 's') save("simon_est.png");
  if (key == 'q' || key == 'Q') exit();
}
