size(400, 400);

stroke(0);
strokeWeight(1);
fill(255);
rect(0,0,width, height);
save("ct1.png");

fill(127);
rect(0,0,width, height);
save("ct2.png");

fill(0);
rect(0,0,width, height);
save("ct3.png");

for (int i = 0; i < 5; i++) {
  fill(125+i);
  rect(0,0,width, height);
  save("ct"+ (i+ 4)+ ".png");
}
