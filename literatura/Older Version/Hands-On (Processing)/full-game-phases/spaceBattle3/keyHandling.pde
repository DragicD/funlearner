boolean keyHeld_Thrust = false;
boolean keyHeld_TurnLeft = false;
boolean keyHeld_TurnRight = false;

void keyPressed() {
  if (keyCode == UP) {
    keyHeld_Thrust = true;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight = true;
  }
  if (keyCode == LEFT) {
    keyHeld_TurnLeft = true;
  }
  if (key == ' ') {
    if (playerShotLifeCycles <= 0) {
      playerShotX = playerX;
      playerShotY = playerY;
      playerShotXV = playerXV + cos(playerAng) * SHOT_SPEED;
      playerShotYV = playerYV + sin(playerAng) * SHOT_SPEED;
      playerShotLifeCycles = SHOT_LIFE_CYCLES;
    }
  }
}

void keyReleased() {
  if (keyCode == UP) {
    keyHeld_Thrust = false;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight = false;
  }
  if (keyCode == LEFT) {
    keyHeld_TurnLeft = false;
  }
  if (key == 'r') {
    resetGame();
  }
}


