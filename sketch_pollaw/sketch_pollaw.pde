size(400, 400);
background(200);
fill(255, 0, 0);
noStroke();

beginShape();
for (int i = 0; i < 20; i++) {
  float angulo = TWO_PI * i / 20;   // la ley: ángulos regulares
  float radio = random(40, 120);    // la lista: radio al azar
  vertex(200 + radio * cos(angulo), 200 + radio * sin(angulo));
}
endShape(CLOSE);
save("pollaw.png");
