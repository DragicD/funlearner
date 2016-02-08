int playerShotLifeCycles = 0;
float playerShotX, playerShotY;
float playerShotXV, playerShotYV;

void playerShotUpdatePosition() {
  playerShotX += playerShotXV;
  playerShotY += playerShotYV;

  // wrap shot if off screen edge
  if (playerShotX < 0) {
    playerShotX += width;
  }
  if (playerShotY < 0) {
    playerShotY += height;
  }
  if (playerShotX > width) {
    playerShotX -= width;
  }
  if (playerShotY > height) {
    playerShotY -= height;
  }

  if (dist(playerShotX, playerShotY, enemyX, enemyY) < TARGET_RADIUS) {
    resetEnemy();
    playerShotLifeCycles = 0;
  }

  playerShotLifeCycles--;
}

void drawPlayerShot()
{
  fill(255,255,255);
  rect(playerShotX-1, playerShotY-1, 3, 3);
}

