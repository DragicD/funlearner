boolean upHeld = false;
boolean downHeld = false;

void keyPressed() {
  if(keyCode == UP) {
    upHeld = true;
  }
  if(keyCode == DOWN) {
    downHeld = true;
  }
}

void keyReleased() {
  if(keyCode == UP) {
    upHeld = false;
  }
  if(keyCode == DOWN) {
    downHeld = false;
  }
}

