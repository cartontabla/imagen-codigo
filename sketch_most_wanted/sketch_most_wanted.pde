import java.net.*;
import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

// ==================================================
// EL CUADRO MÁS DESEADO DEL MUNDO
// Analogía con Komar & Melamid:
// en vez de encuestar a la gente, se le pregunta a la IA
// qué elementos debe tener el cuadro. Ella los decide.
// Imágenes: AI Horde (gratis, sin clave).
// Elementos y composición: LLM de texto (gratis).
// ==================================================

// --- AI Horde ---
String HORDE_KEY = "0000000000";
String API = "https://aihorde.net/api/v2";

// --- negativos ---
String negFondo  = "people, humans, animals, text, watermark, border, frame";
String negFigura = "text, watermark, background, scenery, cropped, out of frame, blurry";

// --- estado ---
JSONArray elementosIA;       // los elementos que decide el LLM
JSONObject composicion;      // la composición que decide el LLM
volatile boolean listo = false;
volatile String mensaje = "Preparando...";
volatile int totalDescargadas = 0;
final int MAX_ESPERA = 30 * 60 * 1000;

// ==================================================
// SETUP
// ==================================================

void setup() {
  size(800, 220);
  pixelDensity(1);

  println("==================================");
  println("EL CUADRO MÁS DESEADO DEL MUNDO");
  println("Los elementos los decide la IA");
  println("Imágenes: AI Horde / Stable Diffusion");
  println("==================================");

  thread("preguntar");
}

// ==================================================
// DRAW
// ==================================================

void draw() {
  background(255);
  fill(0);
  textSize(20);
  text("El cuadro más deseado del mundo", 30, 50);
  textSize(14);
  text(mensaje, 30, 90);
  text("Piezas: " + totalDescargadas, 30, 115);
  if (listo) {
    text("Componiendo el cuadro...", 30, 145);
    componer();
    noLoop();
  }
}

// ==================================================
// GENERAR (los elementos los decide la IA)
// ==================================================

void preguntar() {
  File carpeta = new File(sketchPath("data"));
  if (!carpeta.exists()) carpeta.mkdirs();

  // 1) La IA decide los elementos (la "encuesta").
  mensaje = "La IA decide los elementos...";
  println("----------------------------------");
  println("La IA decide los elementos...");
  elementosIA = pedirElementos();

  if (elementosIA == null) {
    println("La IA no respondió: uso elementos de reserva.");
    elementosIA = elementosDeReserva();
  }

  // 2) Generar cada elemento.
  for (int i = 0; i < elementosIA.size(); i++) {
    JSONObject e = elementosIA.getJSONObject(i);
    String nombre = e.getString("nombre");
    String prompt = e.getString("prompt");
    boolean fondo = e.getBoolean("fondo");

    mensaje = "Generando " + nombre + " (" + (i + 1) + "/" + elementosIA.size() + ")";
    println("----------------------------------");
    println("PIEZA: " + nombre + (fondo ? "  [fondo]" : "  [figura]"));
    println("PROMPT: " + prompt);

    try {
      int ancho = fondo ? 576 : 384;
      int alto  = fondo ? 384 : 576;
      String id = enviarSolicitud(prompt, fondo ? negFondo : negFigura, ancho, alto);
      if (id == null) { println("No se pudo enviar."); continue; }
      println("ID: " + id);

      mensaje = "Esperando " + (i + 1) + "/" + elementosIA.size();
      String url = esperarImagen(id);
      if (url == null) { println("No se obtuvo la imagen."); continue; }

      PImage imagen = descargarImagen(url);
      if (imagen == null) { println("No se pudo decodificar."); continue; }

      if (!fondo) imagen = quitarFondo(imagen);

      String ruta = sketchPath("data/" + nombre + ".png");
      boolean ok = imagen.save(ruta);
      if (ok && new File(ruta).length() > 0) {
        totalDescargadas++;
        println("PNG GUARDADO: " + ruta);
      } else {
        println("ERROR GUARDANDO: " + ruta);
      }

    } catch (Exception ex) {
      println("ERROR EN PIEZA " + i);
      ex.printStackTrace();
    }
  }

  println("==================================");
  println("GENERACIÓN TERMINADA: " + totalDescargadas + "/" + elementosIA.size());
  println("==================================");

  pedirComposicion();
  listo = true;
}

// ==================================================
// LA IA DECIDE LOS ELEMENTOS (la encuesta)
// ==================================================

JSONArray pedirElementos() {
  String prompt =
    "¿Qué elementos debe tener el cuadro más deseado del mundo? "
    + "Devuélveme SOLO un JSON, sin markdown, con esta forma: "
    + "{\"elementos\":[{\"nombre\":\"...\",\"prompt\":\"descripción visual concreta en inglés\",\"fondo\":true|false}, ...]}. "
    + "Un elemento es el fondo (fondo=true, un paisaje, SIN fondo magenta). "
    + "Los otros 3 son figuras (fondo=false), cada una entera y de pie, "
    + "descrita sobre un fondo magenta plano y uniforme (#FF00FF). "
    + "El prompt debe ser concreto, descriptivo y en inglés.";

  String texto = pedirTextoGratis(prompt);
  if (texto == null) return null;
  texto = limpiar(texto);
  JSONObject json = JSONObject.parse(texto);
  if (json == null || !json.hasKey("elementos")) return null;
  return json.getJSONArray("elementos");
}

JSONArray elementosDeReserva() {
  JSONArray a = new JSONArray();
  String[][] res = {
    {"paisaje_fondo", "a realistic landscape painting: blue sky, calm lake, green trees, distant mountains, warm light", "true"},
    {"figura_historica", "a full-body realistic portrait of a dignified old man in 18th-century clothing, standing, on solid magenta #FF00FF", "false"},
    {"ciervo", "a realistic adult deer in profile, full body, on solid magenta #FF00FF", "false"},
    {"aves", "a realistic bird in flight, wings spread, on solid magenta #FF00FF", "false"}
  };
  for (String[] r : res) {
    JSONObject o = new JSONObject();
    o.setString("nombre", r[0]);
    o.setString("prompt", r[1]);
    o.setBoolean("fondo", r[2].equals("true"));
    a.append(o);
  }
  return a;
}

// ==================================================
// AI HORDE: enviar, esperar, consultar
// ==================================================

String enviarSolicitud(String prompt, String negativo, int ancho, int alto) throws Exception {
  URL url = new URL(API + "/generate/async");
  HttpURLConnection c = (HttpURLConnection) url.openConnection();
  c.setRequestMethod("POST");
  c.setDoOutput(true);
  c.setConnectTimeout(30000);
  c.setReadTimeout(60000);
  c.setRequestProperty("Content-Type", "application/json");
  c.setRequestProperty("apikey", HORDE_KEY);
  c.setRequestProperty("Client-Agent", "ProcessingMostWanted:1.0:processing-user");

  JSONObject params = new JSONObject();
  params.setInt("width", ancho);
  params.setInt("height", alto);
  params.setInt("steps", 20);
  params.setInt("n", 1);
  params.setFloat("cfg_scale", 7.5);
  params.setString("sampler_name", "k_euler");
  params.setString("negative_prompt", negativo);

  JSONObject sol = new JSONObject();
  sol.setString("prompt", prompt);
  sol.setJSONObject("params", params);
  sol.setBoolean("nsfw", false);
  sol.setBoolean("censor_nsfw", false);
  sol.setBoolean("r2", true);

  OutputStream os = c.getOutputStream();
  os.write(sol.toString().getBytes("UTF-8"));
  os.flush();
  os.close();

  int codigo = c.getResponseCode();
  println("HTTP solicitud: " + codigo);
  String respuesta = leerRespuesta(c, codigo);
  c.disconnect();

  if (codigo != 202 && codigo != 200) {
    println("Error AI Horde: " + respuesta);
    return null;
  }
  JSONObject json = JSONObject.parse(respuesta);
  if (json == null || !json.hasKey("id")) return null;
  return json.getString("id");
}

String esperarImagen(String id) throws Exception {
  long inicio = millis();
  while (millis() - inicio < MAX_ESPERA) {
    JSONObject estado = consultarJSON(API + "/generate/check/" + id);
    if (estado == null) { Thread.sleep(5000); continue; }

    boolean done = estado.getBoolean("done");
    boolean faulted = estado.getBoolean("faulted");
    int cola = estado.getInt("queue_position");
    int espera = estado.getInt("wait_time");
    mensaje = "En cola: " + cola + " | espera: " + espera + " s";
    println(mensaje);

    if (faulted) { println("Falló."); return null; }
    if (done) {
      JSONObject st = consultarJSON(API + "/generate/status/" + id);
      if (st == null || !st.hasKey("generations")) return null;
      JSONArray gens = st.getJSONArray("generations");
      if (gens.size() == 0) return null;
      return gens.getJSONObject(0).getString("img");
    }
    Thread.sleep(5000);
  }
  println("Tiempo agotado.");
  return null;
}

JSONObject consultarJSON(String direccion) throws Exception {
  URL url = new URL(direccion);
  HttpURLConnection c = (HttpURLConnection) url.openConnection();
  c.setRequestMethod("GET");
  c.setConnectTimeout(30000);
  c.setReadTimeout(60000);
  c.setRequestProperty("apikey", HORDE_KEY);
  c.setRequestProperty("Client-Agent", "ProcessingMostWanted:1.0:processing-user");
  int codigo = c.getResponseCode();
  String respuesta = leerRespuesta(c, codigo);
  c.disconnect();
  if (codigo != 200) { println("Error consulta: " + codigo); return null; }
  return JSONObject.parse(respuesta);
}

String leerRespuesta(HttpURLConnection conexion, int codigo) throws Exception {
  InputStream entrada = (codigo >= 400) ? conexion.getErrorStream() : conexion.getInputStream();
  if (entrada == null) return "";
  ByteArrayOutputStream buffer = new ByteArrayOutputStream();
  byte[] datos = new byte[8192];
  int cantidad;
  while ((cantidad = entrada.read(datos)) != -1) buffer.write(datos, 0, cantidad);
  entrada.close();
  return buffer.toString("UTF-8");
}

PImage descargarImagen(String direccion) throws Exception {
  URL url = new URL(direccion);
  HttpURLConnection c = (HttpURLConnection) url.openConnection();
  c.setRequestMethod("GET");
  c.setConnectTimeout(30000);
  c.setReadTimeout(120000);
  int codigo = c.getResponseCode();
  if (codigo != 200) { c.disconnect(); return null; }

  InputStream entrada = c.getInputStream();
  ByteArrayOutputStream buffer = new ByteArrayOutputStream();
  byte[] datos = new byte[8192];
  int cantidad;
  while ((cantidad = entrada.read(datos)) != -1) buffer.write(datos, 0, cantidad);
  entrada.close();
  c.disconnect();

  byte[] bytes = buffer.toByteArray();
  ImageIO.scanForPlugins();
  BufferedImage bi = ImageIO.read(new ByteArrayInputStream(bytes));
  if (bi == null) return null;

  PImage img = new PImage(bi.getWidth(), bi.getHeight(), ARGB);
  img.loadPixels();
  bi.getRGB(0, 0, bi.getWidth(), bi.getHeight(), img.pixels, 0, bi.getWidth());
  img.updatePixels();
  return img;
}

// ==================================================
// CROMA: quitar el fondo (magenta u otro color liso)
// ==================================================

PImage quitarFondo(PImage origen) {
  origen.loadPixels();
  int w = origen.width, h = origen.height;
  boolean[] visitado = new boolean[w * h];
  int[] cola = new int[w * h];
  int fin = 0;

  java.util.HashSet<Integer> fondos = new java.util.HashSet<Integer>();
  for (int x = 0; x < w; x++) fondos.add(cuantizar(origen.pixels[x]));
  for (int y = 0; y < h; y++) {
    fondos.add(cuantizar(origen.pixels[y * w]));
    fondos.add(cuantizar(origen.pixels[y * w + w - 1]));
  }

  for (int x = 0; x < w; x++) {
    fin = agregarFondo(origen, x, visitado, cola, fin, fondos);
    fin = agregarFondo(origen, (h - 1) * w + x, visitado, cola, fin, fondos);
  }
  for (int y = 0; y < h; y++) {
    fin = agregarFondo(origen, y * w, visitado, cola, fin, fondos);
    fin = agregarFondo(origen, y * w + w - 1, visitado, cola, fin, fondos);
  }

  int inicio = 0;
  while (inicio < fin) {
    int idx = cola[inicio++];
    int x = idx % w, y = idx / w;
    origen.pixels[idx] = origen.pixels[idx] & 0x00FFFFFF;
    if (x > 0)     fin = agregarFondo(origen, idx - 1, visitado, cola, fin, fondos);
    if (x < w - 1) fin = agregarFondo(origen, idx + 1, visitado, cola, fin, fondos);
    if (y > 0)     fin = agregarFondo(origen, idx - w, visitado, cola, fin, fondos);
    if (y < h - 1) fin = agregarFondo(origen, idx + w, visitado, cola, fin, fondos);
  }

  origen.updatePixels();
  return origen;
}

int agregarFondo(PImage img, int idx, boolean[] visitado, int[] cola, int fin, java.util.HashSet<Integer> fondos) {
  if (visitado[idx]) return fin;
  if (!fondos.contains(cuantizar(img.pixels[idx]))) return fin;
  visitado[idx] = true;
  cola[fin++] = idx;
  return fin;
}

int cuantizar(int c) {
  int r = (c >> 16) & 255, g = (c >> 8) & 255, b = c & 255;
  return ((r >> 4) << 8) | ((g >> 4) << 4) | (b >> 4);
}

// ==================================================
// COMPOSICIÓN (la decide la IA)
// ==================================================

void componer() {
  PGraphics lienzo = createGraphics(1024, 768);
  lienzo.beginDraw();

  String nombreFondo = null;
  for (int i = 0; i < elementosIA.size(); i++) {
    JSONObject e = elementosIA.getJSONObject(i);
    if (e.getBoolean("fondo")) { nombreFondo = e.getString("nombre"); break; }
  }
  if (nombreFondo != null) {
    PImage paisaje = loadImage(nombreFondo + ".png");
    if (paisaje != null) {
      float escala = max(1024.0 / paisaje.width, 768.0 / paisaje.height);
      float dw = paisaje.width * escala;
      float dh = paisaje.height * escala;
      lienzo.image(paisaje, (1024 - dw) / 2, (768 - dh) / 2, dw, dh);
    }
  }

  float[][] def = { {200, 300, 0.35}, {560, 500, 0.30}, {700, 120, 0.25} };
  int fig = 0;

  if (composicion != null && composicion.hasKey("elementos")) {
    JSONArray lista = composicion.getJSONArray("elementos");
    for (int i = 0; i < lista.size(); i++) {
      JSONObject e = lista.getJSONObject(i);
      String nombre = e.getString("nombre");
      if (nombre.equals(nombreFondo)) continue;
      PImage p = loadImage(nombre + ".png");
      if (p == null) continue;
      float x = e.getFloat("x"), y = e.getFloat("y"), s = e.getFloat("escala");
      if (x < -p.width || x > 1024 || y < -p.height || y > 768) continue;
      lienzo.image(p, x, y, p.width * s, p.height * s);
    }
  } else {
    for (int i = 0; i < elementosIA.size(); i++) {
      JSONObject e = elementosIA.getJSONObject(i);
      if (e.getBoolean("fondo")) continue;
      PImage p = loadImage(e.getString("nombre") + ".png");
      if (p == null) continue;
      if (fig >= def.length) break;
      lienzo.image(p, def[fig][0], def[fig][1], p.width * def[fig][2], p.height * def[fig][2]);
      fig++;
    }
  }

  lienzo.endDraw();
  lienzo.save("most_wanted.png");

  println("==================================");
  println("COMPOSICIÓN GUARDADA: most_wanted.png");
  println("==================================");
}

// ==================================================
// LA IA DECIDE LA COMPOSICIÓN (LLM gratis)
// ==================================================

void pedirComposicion() {
  mensaje = "La IA decide la composición...";
  println("----------------------------------");
  println("La IA decide la composición...");

  StringBuilder nombres = new StringBuilder();
  for (int i = 0; i < elementosIA.size(); i++) {
    JSONObject e = elementosIA.getJSONObject(i);
    if (!e.getBoolean("fondo")) {
      if (nombres.length() > 0) nombres.append(", ");
      nombres.append("'" + e.getString("nombre") + "'");
    }
  }

  String prompt = "Tengo un lienzo de 1024x768 y estas figuras aisladas (fondo transparente): "
    + nombres.toString() + ". El fondo es un paisaje que ocupa todo el lienzo. "
    + "Devuélveme SOLO un JSON, sin markdown, con la composición: "
    + "{\"elementos\":[{\"nombre\":\"...\",\"x\":...,\"y\":...,\"escala\":...}, ...]}. "
    + "Escala entre 0.1 y 1.0. Composición armoniosa, tipo cuadro clásico.";

  String texto = pedirTextoGratis(prompt);
  if (texto == null) { composicion = null; return; }
  texto = limpiar(texto);
  println("Composición: " + texto);
  composicion = JSONObject.parse(texto);
}

String pedirTextoGratis(String prompt) {
  try {
    String direccion = "https://text.pollinations.ai/" + URLEncoder.encode(prompt, "UTF-8");
    URL url = new URL(direccion);
    HttpURLConnection c = (HttpURLConnection) url.openConnection();
    c.setRequestMethod("GET");
    c.setConnectTimeout(30000);
    c.setReadTimeout(120000);
    int codigo = c.getResponseCode();
    String respuesta = leerRespuesta(c, codigo);
    c.disconnect();
    if (codigo != 200) { println("Error LLM gratis (" + codigo + "): " + respuesta); return null; }
    return respuesta;
  } catch (Exception e) {
    e.printStackTrace();
    return null;
  }
}

String limpiar(String s) {
  s = s.trim();
  if (s.startsWith("```")) {
    s = s.replaceAll("```[a-zA-Z]*", "").replace("```", "").trim();
  }
  return s;
}
