// ============================================================
// Generador streaming de dígitos decimales de PI (Gibbons Spigot)
// ============================================================
class PiDigitGenerator {
  BigInteger q = BigInteger.ONE;
  BigInteger r = BigInteger.ZERO;
  BigInteger t = BigInteger.ONE;
  BigInteger k = BigInteger.ONE;
  BigInteger n = BigInteger.valueOf(3);
  BigInteger l = BigInteger.valueOf(3);

  int next() {
    while (true) {
      // 4*q + r - t
      BigInteger left = q.shiftLeft(2).add(r).subtract(t);
      // n * t
      BigInteger right = n.multiply(t);

      if (left.compareTo(right) < 0) {
        int digit = n.intValue();

        BigInteger oldQ = q;
        BigInteger oldR = r;

        q = oldQ.multiply(BigInteger.TEN);
        r = oldR.subtract(n.multiply(t)).multiply(BigInteger.TEN);
        n = oldQ.multiply(BigInteger.valueOf(3)).add(oldR).multiply(BigInteger.TEN).divide(t).subtract(BigInteger.TEN.multiply(BigInteger.valueOf(digit)));

        return digit;
      } else {
        BigInteger oldQ = q;
        BigInteger oldR = r;
        BigInteger oldT = t;
        BigInteger oldK = k;
        BigInteger oldL = l;

        q = oldQ.multiply(oldK);
        r = oldQ.shiftLeft(1).add(oldR).multiply(oldL);
        t = oldT.multiply(oldL);
        
        // Fórmula corregida del estado del algoritmo de Gibbons
        n = oldQ.multiply(BigInteger.valueOf(7)).multiply(oldK).add(BigInteger.valueOf(2)).add(oldR.multiply(oldL)).divide(oldT.multiply(oldL));
        
        k = oldK.add(BigInteger.ONE);
        l = oldL.add(BigInteger.valueOf(2));
      }
    }
  }
}
