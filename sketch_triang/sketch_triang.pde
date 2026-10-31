size(400, 200);

PGraphics c = createGraphics(400, 200);
c.beginDraw();
c.clear();                              // fondo transparente

// sin relleno
c.noFill();
c.stroke(0);
c.strokeWeight(3);
c.triangle(120, 50, 70, 150, 170, 150);

// sin trazo
c.fill(255, 0, 0);
c.stroke(0);
c.noStroke();
c.triangle(280, 50, 230, 150, 330, 150);

c.endDraw();
image(c, 0, 0);                        // lo muestra en la ventana
c.save("triang.png");           // lo guarda con fondo transparente
