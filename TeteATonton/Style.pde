class Style implements Cloneable {
  int couleur, couleurFond;
  boolean inverse, clignotement;
  boolean selection;

  Style() {
    couleur = 7;
    couleurFond = 0;
    inverse = false;
    clignotement = false;
    selection = false;
  }

  Style(int c, int cf) {
    couleur = c;
    couleurFond = cf;
    inverse = false;
    clignotement = false;
  }

  void affichage() {
    fill(255 * (couleurFond & 1), 255 * (couleurFond & 2), 255 * (couleurFond & 4));
    rect(0, 0, 24, 30);
    fill(255 * (couleur & 1), 255 * (couleur & 2), 255 * (couleur & 4));
    rect(6, 6, 12, 18);
  }

  public Style clone() {
    Style style = null;
    try {
      style = (Style) super.clone();
    } 
    catch(CloneNotSupportedException cnse) {
      cnse.printStackTrace(System.err);
    }
    return style;
  }

  public boolean equals(Object objet) {
    if (objet == null) return false;
    if (objet == this) return true;
    if (!(objet instanceof Style))return false;
    Style autre = (Style)objet;
    return (couleur == autre.couleur) && (couleurFond == autre.couleurFond);
  }
}

