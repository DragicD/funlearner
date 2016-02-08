PImage ufoShip;

int enemyShotLifeCycles = 0;
float enemyShotX, enemyShotY;
float enemyShotXV, enemyShotYV;

void enemyShotUpdatePosition() {
  enemyShotX += enemyShotXV;
  enemyShotY += enemyShotYV;

  // wrap shot if off screen edge
  if (enemyShotX < 0) {
    enemyShotX += width;
  }
  if (enemyShotY < 0) {
    enemyShotY += height;
  }
  if (enemyShotX > width) {
    enemyShotX -= width;
  }
  if (enemyShotY > height) {
    enemyShotY -= height;
  }

  if (dist(enemyShotX, enemyShotY, playerX, playerY) < TARGET_RADIUS) {
    resetPlayer();
    enemyShotLifeCycles = 0;
  }

  enemyShotLifeCycles--;
}

void drawEnemyShot()
{
  fill(255,255,255);
  rect(enemyShotX-1, enemyShotY-1, 3, 3);
}

