size(400, 400);
background(100, 20, 15);     // fondo profundo

noStroke();
fill(220, 110, 40);          // naranja
rect(60, 90, 280, 100);
fill(230, 170, 50);          // amarillo
rect(60, 220, 280, 90);

filter(BLUR, 18);            // los bordes se funden en el fondo
save("rotcko.png");
