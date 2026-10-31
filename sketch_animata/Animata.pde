// Clase Animata: carga un .nmt + .png de animata y anima su esqueleto.
// La animación mueve los puntos de control (articulaciones libres) con un guion
// ondulatorio y luego un solucionador de restricciones (PBD) mantiene las
// longitudes de los huesos, de modo que la malla se deforma sin descuadrarse.

class Animata {
  PImage tex;
  PVector[] vertRest, vertUV, vertPos;   // reposo, coordenadas de textura, deformado
  int[][] caras;                         // triángulos (índices de vértice)
  PVector[] joints, jointsRest;          // articulaciones (actual y en reposo)
  boolean[] fijas;                       // articulaciones ancladas (fixed=1)
  Hueso[] huesos;
  boolean automatico = true;

  // salva de frames (muestreo del guion)
  boolean grabando = false;
  int totalFrames = 24;
  int frameActual = 0;

  Animata(String dir) {
    cargar(dir);
  }

  // --- Carga el .nmt y el .png de data/puppets/<dir>/ ---
  void cargar(String dir) {
    String base = "puppets/" + dir + "/";
    XML xml = loadXML(base + dir + ".nmt");
    XML capa = xml.getChild("layer");

    tex = loadImage(base + capa.getChild("texture").getString("location"));

    XML[] vs = capa.getChild("mesh").getChild("vertices").getChildren("vertex");
    vertRest = new PVector[vs.length];
    vertUV   = new PVector[vs.length];
    vertPos  = new PVector[vs.length];
    for (int i = 0; i < vs.length; i++) {
      vertRest[i] = new PVector(vs[i].getFloat("x"), vs[i].getFloat("y"));
      vertUV[i]   = new PVector(vs[i].getFloat("u"), vs[i].getFloat("v"));
      vertPos[i]  = new PVector(vs[i].getFloat("x"), vs[i].getFloat("y"));
    }

    XML[] fs = capa.getChild("mesh").getChild("faces").getChildren("face");
    caras = new int[fs.length][3];
    for (int i = 0; i < fs.length; i++) {
      caras[i][0] = fs[i].getInt("v0");
      caras[i][1] = fs[i].getInt("v1");
      caras[i][2] = fs[i].getInt("v2");
    }

    XML[] js = capa.getChild("skeleton").getChild("joints").getChildren("joint");
    joints = new PVector[js.length];
    jointsRest = new PVector[js.length];
    fijas = new boolean[js.length];
    for (int i = 0; i < js.length; i++) {
      joints[i]     = new PVector(js[i].getFloat("x"), js[i].getFloat("y"));
      jointsRest[i] = new PVector(js[i].getFloat("x"), js[i].getFloat("y"));
      fijas[i]      = js[i].getInt("fixed") == 1;
    }

    XML[] bs = capa.getChild("skeleton").getChild("bones").getChildren("bone");
    huesos = new Hueso[bs.length];
    for (int i = 0; i < bs.length; i++) {
      Hueso h = new Hueso(bs[i].getInt("j0"), bs[i].getInt("j1"));
      h.longitud = PVector.dist(jointsRest[h.j0], jointsRest[h.j1]);
      XML adj = bs[i].getChild("attached");
      if (adj != null) {
        XML[] atts = adj.getChildren("vertex");
        for (XML a : atts) {
          h.vids.append(a.getInt("id"));
          h.pesos.append(a.getFloat("w"));
          h.cas.append(a.getFloat("ca"));   // vector de desplazamiento local (x)
          h.sas.append(a.getFloat("sa"));   // vector de desplazamiento local (y)
        }
      }
      huesos[i] = h;
    }

    centrar();   // centra la figura en el lienzo
  }

  // --- Ajusta la figura (escala + centrado) al lienzo, sin distorsionar. ---
  void centrar() {
    float minX = Float.MAX_VALUE, minY = Float.MAX_VALUE;
    float maxX = -Float.MAX_VALUE, maxY = -Float.MAX_VALUE;
    for (PVector v : vertRest) {
      minX = min(minX, v.x); maxX = max(maxX, v.x);
      minY = min(minY, v.y); maxY = max(maxY, v.y);
    }
    float w = maxX - minX, alto = maxY - minY;
    float margen = 40;
    float escala = min((width - margen) / w, (height - margen) / alto);
    escala = min(escala, 1.0);   // solo encoge; no agranda figuras pequeñas
    float cx = (minX + maxX) / 2, cy = (minY + maxY) / 2;

    // transformar vértices y articulaciones (escala + centrado)
    for (PVector v : vertRest) v.set((v.x - cx) * escala + width/2, (v.y - cy) * escala + height/2);
    for (PVector v : vertPos)  v.set((v.x - cx) * escala + width/2, (v.y - cy) * escala + height/2);
    for (int i = 0; i < joints.length; i++) {
      joints[i].set((joints[i].x - cx) * escala + width/2, (joints[i].y - cy) * escala + height/2);
      jointsRest[i].set((jointsRest[i].x - cx) * escala + width/2, (jointsRest[i].y - cy) * escala + height/2);
    }

    // escalar los offsets locales y las longitudes de los huesos
    for (Hueso h : huesos) {
      h.longitud *= escala;
      for (int i = 0; i < h.vids.size(); i++) {
        h.cas.set(i, h.cas.get(i) * escala);
        h.sas.set(i, h.sas.get(i) * escala);
      }
    }
  }

  // --- Actualiza: guion + restricciones (o arrastre + restricciones). ---
  void actualizar(boolean arrastrando, float mx, float my, float t) {
    if (arrastrando) {
      automatico = false;        // arrastrar pasa al régimen manual
      arrastrarPunto(mx, my);
    } else if (automatico) {
      guion(t * 0.0035);         // el tiempo se convierte en fase
    }
    simular();          // mantiene las longitudes de los huesos
  }

  // --- Guion: ondulación de los puntos de control según una fase (0..TWO_PI). ---
  void guion(float fase) {
    for (int i = 0; i < joints.length; i++) {
      if (fijas[i]) continue;
      float f = (jointsRest[i].x + jointsRest[i].y) * 0.01 + fase;
      joints[i].set(jointsRest[i].x + 30 * sin(f), jointsRest[i].y + 24 * sin(f * 1.3 + 0.8));
    }
  }

  // --- Salva: captura totalFrames muestreando un ciclo completo del guion. ---
  void iniciarSalva(int n) {
    grabando = true;
    totalFrames = n;
    frameActual = 0;
    new File(sketchPath("frames")).mkdirs();
  }

  boolean pasoSalva() {
    if (!grabando) return false;
    float fase = map(frameActual, 0, totalFrames, 0, TWO_PI);
    guion(fase);
    simular();
    deformar();
    dibujar();
    save("frames/f" + nf(frameActual, 2) + ".png");
    frameActual++;
    if (frameActual >= totalFrames) {
      grabando = false;
      println("salva completada: " + totalFrames + " frames en frames/");
    }
    return grabando;
  }

  // --- Arrastrar: mueve la articulación libre más cercana al ratón. ---
  void arrastrarPunto(float mx, float my) {
    int masCerca = -1;
    float mejor = Float.MAX_VALUE;
    for (int i = 0; i < joints.length; i++) {
      if (fijas[i]) continue;
      float d = dist(mx, my, joints[i].x, joints[i].y);
      if (d < mejor) { mejor = d; masCerca = i; }
    }
    if (masCerca >= 0) joints[masCerca].set(mx, my);
  }

  // --- Restricciones (PBD): cada hueso tiende a recuperar su longitud de reposo. ---
  void simular() {
    for (int iter = 0; iter < 12; iter++) {
      for (Hueso h : huesos) {
        PVector j0 = joints[h.j0], j1 = joints[h.j1];
        float dx = j1.x - j0.x, dy = j1.y - j0.y;
        float len = sqrt(dx*dx + dy*dy);
        if (len < 0.0001) continue;
        float correccion = (h.longitud - len) * 0.5f;
        dx /= len; dy /= len;
        if (!fijas[h.j0]) { j0.x -= correccion*dx; j0.y -= correccion*dy; }
        if (!fijas[h.j1]) { j1.x += correccion*dx; j1.y += correccion*dy; }
      }
    }
  }

  // --- Deformación (piel y huesos): cada vértice sigue al centro de sus huesos. ---
  void deformar() {
    float[] ax = new float[vertPos.length];
    float[] ay = new float[vertPos.length];
    float[] aw = new float[vertPos.length];

    for (Hueso h : huesos) {
      PVector j0 = joints[h.j0], j1 = joints[h.j1];
      float cx = (j0.x + j1.x) * 0.5f, cy = (j0.y + j1.y) * 0.5f;   // centro del hueso
      float dx = j1.x - j0.x, dy = j1.y - j0.y;
      float len = sqrt(dx*dx + dy*dy);
      if (len < 0.0001) len = 0.0001;
      dx /= len; dy /= len;                                          // dirección unitaria
      for (int i = 0; i < h.vids.size(); i++) {
        int v = h.vids.get(i);
        float ca = h.cas.get(i), sa = h.sas.get(i), w = h.pesos.get(i);
        float tx = cx + (dx*ca - dy*sa);
        float ty = cy + (dx*sa + dy*ca);
        ax[v] += w*tx; ay[v] += w*ty; aw[v] += w;
      }
    }
    for (int v = 0; v < vertPos.length; v++) {
      if (aw[v] > 0) vertPos[v].set(ax[v]/aw[v], ay[v]/aw[v]);
      else vertPos[v].set(vertRest[v].x, vertRest[v].y);
    }
  }

  // --- Dibujo: malla triangulada con textura. ---
  void dibujar() {
    noStroke();
    beginShape(TRIANGLES);
    texture(tex);
    for (int[] f : caras) {
      for (int k = 0; k < 3; k++) {
        int v = f[k];
        vertex(vertPos[v].x, vertPos[v].y, vertUV[v].x * tex.width, vertUV[v].y * tex.height);
      }
    }
    endShape();
  }
}
