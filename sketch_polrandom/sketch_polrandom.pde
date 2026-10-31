size(400, 400);
background(200);
fill(255, 0, 0);
noStroke();

beginShape();
for (int i = 0; i < 10; i++) {
  vertex(random(width), random(height));
}
endShape(CLOSE);
save("polrandn.png");
