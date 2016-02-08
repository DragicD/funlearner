float enemyX, enemyY;
float enemyMoveToX, enemyMoveToY;

void resetEnemy()
{
  enemyX = width/4;
  enemyY = height/4;
  enemyMoveToX = enemyX;
  enemyMoveToY = enemyY;
  enemyShotLifeCycles = 0;
}

void enemyUpdatePosition()
{
  if (enemyX < enemyMoveToX - ENEMY_MOVE_SPEED) {
    enemyX += ENEMY_MOVE_SPEED;
  } 
  else if (enemyX > enemyMoveToX + ENEMY_MOVE_SPEED) {
    enemyX -= ENEMY_MOVE_SPEED;
  } 
  else {
    enemyMoveToX = random(width);
  }

  if (enemyY < enemyMoveToY - ENEMY_MOVE_SPEED) {
    enemyY += ENEMY_MOVE_SPEED;
  } 
  else if (enemyY > enemyMoveToY + ENEMY_MOVE_SPEED) {
    enemyY -= ENEMY_MOVE_SPEED;
  } 
  else {
    enemyMoveToY = random(height);
  }

  if (enemyShotLifeCycles <= 0 && random(150)<3) {
    enemyShotX = enemyX;
    enemyShotY = enemyY;
    float angTo = atan2(playerY-enemyY, playerX-enemyX);
    enemyShotXV = cos(angTo) * SHOT_SPEED + random(-2.0, 2.0);
    enemyShotYV = sin(angTo) * SHOT_SPEED + random(-2.0, 2.0);
    enemyShotLifeCycles = SHOT_LIFE_CYCLES;
  }
}

void drawEnemy()
{
  pushMatrix();
  translate(enemyX, enemyY);
  image(ufoShip,-ufoShip.width/2,-ufoShip.height/2);
  popMatrix();
}

