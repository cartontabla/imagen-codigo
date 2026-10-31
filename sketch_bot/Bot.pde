// Bot.pde
// Clase Bot: circunferencia con dirección, que se mueve y reacciona
// a las intersecciones. El radio se colorea en rojo solo al tocarse.

class Bot {
  float x, y;          // posición
  float vx, vy;        // dirección (velocidad)
  float radio;         // radio
  boolean tocando;     // si está tocando a otro bot

  Bot(float x, float y, float radio) {
    this.x = x;
    this.y = y;
    this.radio = radio;
    float a = random(TWO_PI);
    this.vx = cos(a) * 1.5;
    this.vy = sin(a) * 1.5;
  }

  // moverse y rebotar en los bordes
  void mover() {
    x += vx;
    y += vy;
    if (x < radio || x > width - radio) vx *= -1;
    if (y < radio || y > height - radio) vy *= -1;
  }

  // controlar la dirección en base a las intersecciones (repeler)
  void intersectar(Bot otro) {
    if (dist(x, y, otro.x, otro.y) < radio + otro.radio) {
      tocando = true;
      otro.tocando = true;
      float a = atan2(y - otro.y, x - otro.x);   // dirección de separación
      vx = cos(a) * 1.5;
      vy = sin(a) * 1.5;
      otro.vx = -cos(a) * 1.5;
      otro.vy = -sin(a) * 1.5;
    }
  }

  // dibujar: circunferencia blanca; radio rojo solo al tocarse
  void dibujar() {
    stroke(255);
    strokeWeight(5);
    noFill();
    ellipse(x, y, 2 * radio, 2 * radio);
    float a = atan2(vy, vx);
    if (tocando)
      stroke(255, 0, 0);    // rojo mientras dura el contacto
    else
      stroke(255);          // blanco el resto del tiempo
    line(x, y, x + cos(a) * radio, y + sin(a) * radio);
    tocando = false;        // se reinicia para el siguiente fotograma
  }
}
