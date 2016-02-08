boolean holdLeft,
        holdRight,
        holdUp,
        holdDown;

void toggleSignal(boolean keyTo) {
  if(keyCode == LEFT) {
    holdLeft = keyTo;
  }
  if(keyCode == RIGHT) {
    holdRight = keyTo;
  }
  if(keyCode == UP) {
    holdUp = keyTo;
  }
  if(keyCode == DOWN) {
    holdDown = keyTo;
  }
}

void keyPressed() {
  toggleSignal(true);
}

void keyReleased() {
  toggleSignal(false);
}
