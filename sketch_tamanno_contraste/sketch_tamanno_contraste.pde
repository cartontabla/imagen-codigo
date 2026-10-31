// contraste02: el contraste de tamaño
size(400, 220);
background(255);
noStroke();
fill(0);

float grande = 200;                    // el lado del cuadrado grande
float pequeno = 50;                    // el lado del pequeño

rect(40, 10, grande, grande);                              // el grande
rect(40 + grande + 60, 10 + grande - pequeno, pequeno, pequeno);  // el pequeño

// la varianza mide el contraste, igual que antes medía el tono
float media = (grande + pequeno) / 2;
float var = ((grande - media) * (grande - media) +
             (pequeno - media) * (pequeno - media)) / 2;
println("varianza de los lados: " + var);   // 5625
save("ctt.png");
