PImage source;
PVector positionImage;
boolean grille;
boolean esquisse;
Caractere[] portrait;
Caractere caractereCourant;
Style styleCourant;
PVector decalage, decalageStyle;

void setup() {
  size(1296, 720);
  source = loadImage("Mitterrand.jpg");
  positionImage = new PVector(0, 0);
  grille = true;
  esquisse = true;
  JSONArray tableau = loadJSONArray("data.json");
  portrait = new Caractere[960];
  for (int i = 0; i < portrait.length; i++) {
    JSONObject car = tableau.getJSONObject(i);
    portrait[i] = new Caractere(car);
  }
  decalage = new PVector(0, 0);
  decalageStyle = new PVector(0, 0);
  styleCourant = new Style();
  caractereCourant = null;
}

void draw() {
  background(30, 60, 110);
  image(source, positionImage.x, positionImage.y);
  noStroke();

  // Affichage menu 1
  pushMatrix();
  translate(960, 0);
  for (int i = 0; i < 64; i++) {
    pushMatrix();
    translate((i / 16) * 24, (i % 16) * 30);
    affichageMenu(128 + i);
    popMatrix();
  }
  translate(96, 0);
  for (int i = 0; i < 64; i++) {
    pushMatrix();
    translate((i / 16) * 24, (i % 16) * 30);
    affichageMenu(192 + i);
    popMatrix();
  }
  translate(96, 0);
  for (int i = 0; i < 96; i++) {
    pushMatrix();
    translate((i / 16) * 24, (i % 16) * 30);
    //affichageMenu(192 + i);

    popMatrix();
  }
  popMatrix();
  stroke(0, 0, 0);
  for (int i = 40; i < 54; i++) {
    line(i * 24, 0, i * 24, 480);
  }
  for (int i = 0; i <= 16; i++) {
    line(960, i * 30, width, i * 30);
  }

  // Affichage menu style
  pushMatrix();
  noStroke();
  translate(960, 600);
  for (int i = 0; i < 8; i++) {
    fill(255 * (i & 1), 255 * (i & 2), 255 * (i & 4));
    rect(i * 24, 0, 24, 30);
    rect(i * 24, 60, 24, 30);
  }
  translate(84, -60);
  fill(255);
  //rect(0, 0, 100, 100);
  styleCourant.affichage();
  popMatrix();

  // Affichage du caneva
  if (esquisse) {
    for (int i = 0; i < portrait.length; i++) {
      pushMatrix();
      translate((i % 40) * 24, (i / 40) * 30);
      portrait[i].affichage();
      popMatrix();
    }
  }

  // Affichage de la grille
  stroke(0);
  if (grille) {
    for (int i = 0; i < 40; i++) {
      line(i * 24, 0, i * 24, height);
    }
    for (int i = 0; i < 24; i++) {
      line(0, i * 30, 960, i * 30);
    }
  }

  // Affichage du caractere en mouvement
  if (caractereCourant != null) {
    pushMatrix();
    if (mouseX < 960) {
      translate(24 * (mouseX / 24), 30 * (mouseY / 30));
    } else {
      translate(mouseX - decalage.x, mouseY - decalage.y);
    }
    if (caractereCourant.valeur >=0) {
      caractereCourant.affichage();
    }
    popMatrix();
  }

  // Affichage du Style en mouvement
  if (styleCourant.selection) {
    pushMatrix();
    if (mouseX < 960) {
      translate(24 * (mouseX / 24), 30 * (mouseY / 30));
    } else {
      translate(mouseX - decalageStyle.x, mouseY - decalageStyle.y);
    }
    styleCourant.affichage();
    popMatrix();
  }
}

void affichageMenu(int x) {
  noStroke();
  for (int i = 0; i < 10; i++) {
    int ligne = police[x][i];
    for (int j = 0; j < 8; j++) {
      if ((ligne & (1 << (7 - j))) != 0) {
        fill(255 * (styleCourant.couleur & 1), 255 * (styleCourant.couleur & 2), 255 * (styleCourant.couleur & 4));
      } else {
        fill(255 * (styleCourant.couleurFond & 1), 255 * (styleCourant.couleurFond & 2), 255 * (styleCourant.couleurFond & 4));
      }
      noStroke();
      rect(j * 3, i * 3, 3, 3);
    }
  }
}

void keyPressed() {
  if (key == 'g') {
    grille = !grille;
  }
  if (key == ' ') {
    esquisse = !esquisse;
  }
  if (key == 'i') {
    PImage imago = createImage(960, 720, RGB);
    imago.loadPixels();
    loadPixels();
    for (int j = 0; j < imago.height; j++) {
      for (int i = 0; i < imago.width; i++) {
        imago.pixels[j * imago.width + i] = pixels[j * width + i];
      }
    }
    imago.updatePixels();
    imago.save("Mitterand.png");
  }
  if (key == 's') {
    JSONArray tableau = new JSONArray();
    for (int i = 0; i < portrait.length; i++) {
      JSONObject car = new JSONObject();
      car.setInt("valeur", portrait[i].valeur);
      car.setInt("couleur", portrait[i].style.couleur);
      car.setInt("couleurFond", portrait[i].style.couleurFond);
      tableau.setJSONObject(i, car);
    }
    saveJSONArray(tableau, "data.json");
  }
  if (key == 'e') {
    exportation();
  }
  if (keyCode == UP) {
    positionImage.y -= 1;
  }
  if (keyCode == DOWN) {
    positionImage.y += 1;
  }
  if (keyCode == LEFT) {
    positionImage.x -= 1;
  }
  if (keyCode == RIGHT) {
    positionImage.x += 1;
  }
}

void mousePressed() {
  if ((mouseX >= 960) && (mouseX < width) && (mouseY > 0) && (mouseY < 480)) {
    caractereCourant = new Caractere(128 + (mouseY / 30) + ((mouseX - 960) / 24) * 16, styleCourant);
    decalage.set((mouseX - 960) % 24, mouseY % 30);
  }
  if (mouseX < 960) {
    if (keyCode == SHIFT) {
      styleCourant = portrait[(mouseY / 30) * 40 + (mouseX / 24)].style.clone();
      decalageStyle.set(mouseX - 1044, mouseY - 540);
      styleCourant.selection = true;
    } else {
      caractereCourant = portrait[(mouseY / 30) * 40 + (mouseX / 24)].clone();
      decalage.set((mouseX - 960) % 24, mouseY % 30);
    }
  }
  if ((mouseX > 960) && (mouseX < width) && (mouseY > 600) && (mouseY < 630)) {
    styleCourant.couleur = (mouseX - 960) / 24;
  }
  if ((mouseX > 960) && (mouseX < width) && (mouseY > 660) && (mouseY < 720)) {
    styleCourant.couleurFond = (mouseX - 960) / 24;
  }
  if ((mouseX > 960) && (mouseX < width) && (mouseY > 660) && (mouseY < 720)) {
  }
  if ((mouseX > 1044) && (mouseX < 1068) && (mouseY > 540) && (mouseY < 570)) {
    decalageStyle.set(mouseX - 1044, mouseY - 540);
    styleCourant.selection = true;
  }
}

void mouseReleased() {
  if ((mouseX < 960) && (caractereCourant != null)) {
    portrait[(mouseY / 30) * 40 + (mouseX / 24)] = caractereCourant.clone();
  }
  if ((mouseX < 960) && styleCourant.selection) {
    portrait[(mouseY / 30) * 40 + (mouseX / 24)].style = styleCourant.clone();
  }
  caractereCourant = null;
  styleCourant.selection = false;
}

void exportation() {
  byte[] tableau = {
    0x0C, 0x0E
  };
  byte[] ajout = {
  };
  int jeuCourant = -1;
  Style styleRef = new Style(-1, -1);
  for (int i = 0; i < portrait.length; i++) {
    // Verif couleur identique
    if (styleRef.couleur != portrait[i].style.couleur) {
      byte[] c = {
        0X1B, (byte)(0x40 + portrait[i].style.couleur)
      };
      tableau = concat(tableau, c);
      styleRef.couleur = portrait[i].style.couleur;
    }
    // Verif couleur fond identique
    if (styleRef.couleurFond != portrait[i].style.couleurFond) {
      byte[] cf = {
        0X1B, (byte)(0x50 + portrait[i].style.couleurFond)
      };
      tableau = concat(tableau, cf);
      styleRef.couleurFond = portrait[i].style.couleurFond;
    }
    // Vérif jeu caractère identique
    if ((portrait[i].valeur / 64) != jeuCourant) {
      switch (portrait[i].valeur / 64) {
      case 0 :
        break;
      case 1 :
        break;
      case 2 :
        byte[] disjoint = {
          0x1B, 0x5A
        };
        tableau = concat(tableau, disjoint);
        break;
      case 3 :
        byte[] normal = {
          0x1B, 0x59
        };
        tableau = concat(tableau, normal);
        break;
      }
      jeuCourant = portrait[i].valeur / 64;
    }
    tableau = append(tableau, correspondance[(char)portrait[i].valeur]);
  }
  byte[] attente = {
  };
  for (int i = 0; i < 480; i++) {
    tableau = append(tableau, (byte)0x14);
  }
  tableau = concat(tableau, attente);

  byte[] score = {
    0x0F, // Mode Texte
    0x1F, 70, 95, // Deplacement du curseur y + 64, x + 64
    0x1B, 0x4F, // Double Grandeur
    0x1B, 0x47, 
    0x1B, 0x50, // Fond noir
    0x1B, 0x48, // Caractère blanc
    0x35, 0x31, // 51
    0x1B, 0x4C, // Taille normal
    0x1B, 0x4D, // Double hauteur
    0x2C, // ,
    0x1B, 0x4F, // Double grandeur
    0x37 // 7
  };
  tableau = concat(tableau, score);
  saveBytes("export.vdt", tableau);
}