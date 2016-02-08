// note: since not in a class, these are global (visible in any file)
boolean keyHeld_Thrust = false;
boolean keyHeld_TurnLeft = false;
boolean keyHeld_TurnRight = false;

final int PRESSED_DOWN = 2;
final int PRESSED_HELD = 1;
final int PRESSED_UP = 0;

boolean keyPressed_Space = false;
int keyPressLock_Space = PRESSED_UP;

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
  if (key == ' ' && keyPressLock_Space == PRESSED_UP) {
    keyPressLock_Space = PRESSED_DOWN;
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
  if (key == ' ') {
    keyPressLock_Space = PRESSED_UP;
  }
}

void forgetPressedKeys() {
  if (keyPressLock_Space == PRESSED_DOWN) {
    keyPressLock_Space = PRESSED_HELD;
  }
  keyPressed_Space = false;
}

