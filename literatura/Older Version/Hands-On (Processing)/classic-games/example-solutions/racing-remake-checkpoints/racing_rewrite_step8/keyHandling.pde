// note: since not in a class, these are global (visible in any file)
boolean keyHeld_Gas_P1 = false;
boolean keyHeld_Reverse_P1 = false;
boolean keyHeld_TurnLeft_P1 = false;
boolean keyHeld_TurnRight_P1 = false;

boolean keyHeld_Gas_P2 = false;
boolean keyHeld_Reverse_P2 = false;
boolean keyHeld_TurnLeft_P2 = false;
boolean keyHeld_TurnRight_P2 = false;

void setControl(boolean setTo) {
  if (keyCode == UP) {
    keyHeld_Gas_P1 = setTo;
  }
  if (keyCode == DOWN) {
    keyHeld_Reverse_P1 = setTo;
  }
  if (keyCode == LEFT) {
    keyHeld_TurnLeft_P1 = setTo;
  }
  if (keyCode == RIGHT) {
    keyHeld_TurnRight_P1 = setTo;
  }
  
  if (key == 'w') {
    keyHeld_Gas_P2 = setTo;
  }
  if (key == 's') {
    keyHeld_Reverse_P2 = setTo;
  }
  if (key == 'a') {
    keyHeld_TurnLeft_P2 = setTo;
  }
  if (key == 'd') {
    keyHeld_TurnRight_P2 = setTo;
  }
}

void keyPressed() {
  setControl(true);
}

void keyReleased() {
  setControl(false);
}

