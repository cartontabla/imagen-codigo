size(400, 200);

PGraphics c = createGraphics(400, 200);
c.beginDraw();
c.clear();                              // fondo transparente

// el contorno solo aparece con una figura de verdad
c.ellipseMode(CENTER);
c.fill(255, 0, 0);
c.stroke(0);
c.strokeWeight(50);
c.ellipse(120, 100, 80, 80);   // solo el borde

// el punto ignora fill(): el rojo no pinta nada, sale negro
c.rectMode(CENTER);
c.fill(255, 0, 0);
c.stroke(0);
c.strokeWeight(50);
c.rect(280, 100, 80, 80);      // círculo negro, relleno, sin contorno

c.endDraw();
image(c, 0, 0);                        // lo muestra en la ventana
c.save("puntocontorno.png");           // lo guarda con fondo transparente
