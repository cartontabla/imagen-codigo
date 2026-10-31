size(400, 400);
background(200);

float paso = (400 - 2 * 60) / 6;
float x = 60;
float y = 200;

for (int i = 0; i < 6; i++) {
  float xn = x + paso;
  float yn = random(60, 340);

  stroke(255 * (i / 5.0));         // de negro a blanco
  strokeWeight(2);
  line(x, y, xn, yn);
  //save("linzig" + (i + 1) + ".png");
  
  x = xn;
  y = yn;
}
save("linzig.png");
