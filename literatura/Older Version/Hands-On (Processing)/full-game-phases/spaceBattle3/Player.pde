PImage playerShip;

float playerX, playerY;
float playerXV, playerYV;
float playerAng;

void resetPlayer()
{
  // reminder: only call this after setting size() so that width/height are valid
  playerX = width/2;

  playerY = height/2;
  playerXV = 0.0;
  playerYV = 0.0;
  playerAng = 0.0;
  playerShotLifeCycles = 0;
}

void playerUpdatePosition() {
  if (keyHeld_Thrust) {
    playerXV += cos(playerAng) * THRUST_FORCE;
    playerYV += sin(playerAng) * THRUST_FORCE;
  }
  if (keyHeld_TurnLeft) {
    playerAng -= PLAYER_TURN_RATE;
  }
  if (keyHeld_TurnRight) {
    playerAng += PLAYER_TURN_RATE;
  }

  playerX += playerXV;
  playerY += playerYV;
  playerXV *= THRUST_DECAY_MULT;
  playerYV *= THRUST_DECAY_MULT;

  // wrap player if off screen edge
  if (playerX < 0) {
    playerX += width;
  }
  if (playerY < 0) {
    playerY += height;
  }
  if (playerX > width) {
    playerX -= width;
  }
  if (playerY > height) {
    playerY -= height;
  }
}

void drawPlayer()
{
  pushMatrix();
  translate(playerX, playerY);
  rotate(playerAng);
  image(playerShip,-playerShip.width/2,-playerShip.height/2);
  popMatrix();
}


