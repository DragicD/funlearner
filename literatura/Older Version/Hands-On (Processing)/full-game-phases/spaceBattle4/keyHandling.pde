// note: since not in a class, these are global (visible in any file)
boolean keyHeld_Thrust = false;
boolean keyHeld_TurnLeft = false;
boolean keyHeld_TurnRight = false;
boolean keyPressed_Space = false;

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
    keyPressed_Space = true;
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

void forgetPressedKeys() {
  keyPressed_Space = false;
}

