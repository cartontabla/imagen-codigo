size(400, 400);

color[] paleta = {
  color(114, 79, 66),  color(194, 142, 124), color(91, 120, 154),
  color(91, 108, 64),  color(131, 127, 173), color(98, 189, 170),
  color(223, 122, 49), color(68, 88, 166),   color(195, 79, 94),
  color(93, 60, 105),  color(156, 186, 59),  color(229, 162, 44),
  color(38, 62, 146),  color(61, 146, 68),   color(177, 53, 57),
  color(235, 199, 26), color(190, 79, 146),  color(1, 135, 165),
  color(240, 241, 236),color(202, 203, 203), color(162, 164, 164),
  color(121, 121, 120),color(83, 85, 85),    color(51, 51, 50)
};

PGraphics c = createGraphics(400, 400);   // nace transparente
c.beginDraw();
c.clear();                                // asegura el fondo transparente

int n = 1000;
int i = 20;
float alfa = map(i, 0, 23, 15, 255);
int cuantos = int(n * map(i, 0, 23, 0.15, 1));

for (int j = 0; j < cuantos; j++) {
  color col = paleta[int(random(paleta.length))];
  c.stroke(col, alfa);
  c.strokeWeight(random(2, 20));
  c.point(random(400), random(400));      // usa 400, no width/height
}

c.endDraw();
image(c, 0, 0); 
c.save("suppunt.png");
