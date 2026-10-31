PImage img;
size(800, 800);
img = loadImage("foto.jpg");
int lado = min(img.width, img.height);
img =  img.get((img.width - lado) / 2, (img.height - lado) / 2, lado, lado);
img.resize(width, height);
image(img, 0,0);
