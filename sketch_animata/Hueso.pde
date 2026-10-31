// Hueso: dos articulaciones y los vértices de la malla atados a él.
class Hueso {
  int j0, j1;
  float longitud;                    // longitud del hueso en reposo
  IntList vids = new IntList();
  FloatList pesos = new FloatList();
  FloatList cas = new FloatList();   // ca del .nmt (offset local x)
  FloatList sas = new FloatList();   // sa del .nmt (offset local y)
  Hueso(int a, int b) { j0 = a; j1 = b; }
}
