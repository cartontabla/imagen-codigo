size(400, 200);

PGraphics c = createGraphics(400, 200);   // nace transparente
c.beginDraw();
c.clear();                                // asegura el fondo transparente

c.stroke(0);
c.strokeWeight(120);

c.strokeCap(ROUND);     // cuerpo redondo: un círculo
c.point(120, 100);

c.strokeCap(PROJECT);   // cuerpo cuadrado: un cuadrado
c.point(280, 100);

c.endDraw();
image(c, 0, 0);          // lo muestra en la ventana
c.save("circrect.png");  // lo guarda con fondo transparente
