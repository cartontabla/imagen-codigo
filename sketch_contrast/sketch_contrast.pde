size(400, 400);

stroke(0);
background(255);
save("ct1.png");
background(127);
save("ct2.png");
background(0);
save("ct3.png");

for (int i = 0; i < 5; i++) {
  background(125+i);
  save("ct"+ i+ 4+ ".png");
}
