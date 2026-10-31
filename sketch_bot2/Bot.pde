// Bot.pde
// Clase Bot con aprendizaje por refuerzo (Q-learning simple).
// Estado (2): tocando / no tocando.
// Acción (3): girar a la izquierda, seguir recto, girar a la derecha.
// Recompensa: al no tocar, recto (+1) y girar (0); al tocar, girar (+1)
// y recto (-1); chocar con el borde (-1). Así aprende a desplazarse
// en una dirección y a girar (cambiar de comportamiento) al colisionar.

class Bot {
  float x, y;          // posición
  float radio;         // radio
  float angulo;        // dirección (ángulo)
  boolean tocando;     // si está tocando a otro bot

  // Q-learning: Q[estado][acción]
  float[][] Q = new float[2][3];
  float alpha = 0.1;    // tasa de aprendizaje
  float gamma = 0.9;    // descuento
  float epsilon = 0.1;  // exploración (ε-greedy)

  Bot(float x, float y, float radio) {
    this.x = x;
    this.y = y;
    this.radio = radio;
    this.angulo = random(TWO_PI);
  }

  // un paso de RL: observar, decidir, ejecutar, recibir recompensa, aprender
  void actuar(Bot[] otros) {
    // 1. observar el estado
    int estado = tocando ? 1 : 0;

    // 2. decidir la acción (ε-greedy)
    int accion;
    if (random(1) < epsilon)
      accion = (int) random(3);          // explorar: al azar
    else {
      accion = 0;                        // explotar: la mejor Q
      if (Q[estado][1] > Q[estado][accion]) accion = 1;
      if (Q[estado][2] > Q[estado][accion]) accion = 2;
    }

    // 3. ejecutar la acción (cambiar la dirección)
    if (accion == 0) angulo -= 0.1;      // girar a la izquierda
    else if (accion == 2) angulo += 0.1; // girar a la derecha
    // accion == 1: recto (no cambia el ángulo)

    // 4. moverse
    x += cos(angulo) * 0.5;
    y += sin(angulo) * 0.5;

    // 5. recibir la recompensa
    boolean borde = false;
    if (x < radio || x > width - radio) {
      x = constrain(x, radio, width - radio);
      angulo = PI - angulo;
      borde = true;
    }
    if (y < radio || y > height - radio) {
      y = constrain(y, radio, height - radio);
      angulo = -angulo;
      borde = true;
    }

    tocando = false;
    for (Bot o : otros)
      if (o != this && dist(x, y, o.x, o.y) < radio + o.radio)
        tocando = true;

    float recompensa;
    if (borde)
      recompensa = -1;
    else if (tocando)
      recompensa = (accion == 1) ? -1 : 1;   // al tocar: girar bien, recto mal
    else
      recompensa = (accion == 1) ? 1 : 0;     // sin tocar: recto bien, girar neutro

    // 6. aprender (actualización de Q-learning)
    int nuevo = tocando ? 1 : 0;
    float maxQ = Q[nuevo][0];
    if (Q[nuevo][1] > maxQ) maxQ = Q[nuevo][1];
    if (Q[nuevo][2] > maxQ) maxQ = Q[nuevo][2];
    Q[estado][accion] += alpha * (recompensa + gamma * maxQ - Q[estado][accion]);
  }

  // dibujar: circunferencia blanca; radio rojo solo al tocarse
  void dibujar() {
    stroke(255);
    strokeWeight(5);
    noFill();
    ellipse(x, y, 2 * radio, 2 * radio);
    if (tocando)
      stroke(255, 0, 0);    // rojo mientras dura el contacto
    else
      stroke(255);          // blanco el resto del tiempo
    line(x, y, x + cos(angulo) * radio, y + sin(angulo) * radio);
  }
}
