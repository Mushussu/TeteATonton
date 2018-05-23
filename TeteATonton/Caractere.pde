class Caractere implements Cloneable {
  int valeur;
  Style style;
  int couleur, couleurFond;
  boolean inverse, clignotement;

  Caractere() {
    valeur = -1;
    couleur = 7;
    couleurFond = 0;
    style = new Style();
  }

  Caractere(int v) {
    valeur = v;
    couleur = 7;
    couleurFond = 0;
    style = new Style();
  }

  Caractere(int v, Style s) {
    valeur = v;
    style = s;
  }

  Caractere(JSONObject car) {
    valeur = car.getInt("valeur");
    style = new Style(car.getInt("couleur"), car.getInt("couleurFond"));
  }

  void affichage() {
    noStroke();
    if (valeur >= 0) {
      for (int i = 0; i < 10; i++) {
        int ligne = police[valeur][i];
        for (int j = 0; j < 8; j++) {
          if ((ligne & (1 << (7 - j))) != 0) {
            fill(255 * (style.couleur & 1), 255 * (style.couleur & 2), 255 * (style.couleur & 4));
          } else {
            fill(255 * (style.couleurFond & 1), 255 * (style.couleurFond & 2), 255 * (style.couleurFond & 4));
          }
          rect(j * 3, i * 3, 3, 3);
        }
      }
    }
  }

  byte[] export() {
    byte[] b = new byte[0];
    return b;
  }

  public Caractere clone() {    
    Caractere caractere = null;
    try {
      caractere = (Caractere) super.clone();
    } 
    catch(CloneNotSupportedException cnse) {
      cnse.printStackTrace(System.err);
    }
    caractere.style = style.clone();
    return caractere;
  }

  public boolean equals(Object objet) {
    if (objet == null) return false;
    if (objet == this) return true;
    if (!(objet instanceof Caractere))return false;
    Caractere autre = (Caractere)objet;
    return (valeur == autre.valeur) && autre.style.equals(style);
  }
}