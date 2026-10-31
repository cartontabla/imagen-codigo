size(400, 400);
background(255);

// líneas verticales y horizontales en posiciones desiguales: así los
// rectángulos salen de tamaños distintos y no una cuadrícula uniforme
float[] xs = sort(new float[]{0, random(80, 180), random(220, 330), width});
float[] ys = sort(new float[]{0, random(80, 180), random(220, 330), height});

// mucha blancura y algún primario, como el Mondrian de verdad
color[] paleta = {
  color(255),          // blanco
  color(255),          // blanco
  color(255),          // blanco
  color(230, 30, 30),  // rojo
  color(240, 200, 0),  // amarillo
  color(20, 50, 180),  // azul
  color(150)           // gris
};

stroke(0);
strokeWeight(8);

for (int i = 0; i < xs.length - 1; i++) {
  for (int j = 0; j < ys.length - 1; j++) {
    fill(paleta[int(random(paleta.length))]);
    rect(xs[i], ys[j], xs[i+1] - xs[i], ys[j+1] - ys[j]);
  }
}
save("mondrian.png");
