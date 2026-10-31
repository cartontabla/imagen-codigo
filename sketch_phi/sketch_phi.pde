// la construcción clásica: el cuadrado, el arco y el corte áureo
size(400, 280);
background(255);

float a = 200;                     // el lado del cuadrado
float x0 = 40, y0 = 40;            // su esquina superior izquierda
float phi = (1 + sqrt(5)) / 2;
float mx = x0 + a / 2;             // el punto medio de la base
float my = y0 + a;

// 1. el cuadrado
fill(240);
stroke(0);
rect(x0, y0, a, a);

float ex = x0 + a * phi;
fill(200);
rect(x0 + a, y0, ex - x0 - a, a);

float r = a * sqrt(5) / 2;
stroke(0);
noFill();
arc(mx, my, 2 * r, 2 * r, -atan(2), 0);

line(x0, my, ex, my);

fill(0);
ellipse(ex, my, 8, 8);

// 5. b: el segmento que el arco añade al lado del cuadrado
strokeWeight(2);
line(x0 + a, my, ex, my);
save("phi.png");
