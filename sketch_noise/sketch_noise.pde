size(400, 400);
pixelDensity(1);          // un píxel de código = un píxel de pantalla
background(255);
loadPixels();
for (int y = 0; y < height; y++) {
  for (int x = 0; x < width; x++) {
    float n = noise(x * 0.01, y * 0.01);
    pixels[y * width + x] = color(n * 255);
  }
}
updatePixels();
save("noise.png");
