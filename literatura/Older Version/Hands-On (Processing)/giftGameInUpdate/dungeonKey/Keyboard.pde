class Keyboard {
  Boolean holdingUp,holdingRight,holdingLeft,holdingDown;
  
  Keyboard() {
    holdingUp=holdingRight=holdingLeft=holdingDown=false;
  }
  
  /* The way that Processing, and many programming languages/environments, deals with keys is
   * treating them like events (something can happen the moment it goes down, or when it goes up).
   * Because we want to treat them like buttons - checking "is it held down right now?" - we need to
   * use those pressed and released events to update some true/false values that we can check elsewhere.
   */

  void pressKey() {
    if (keyCode == UP) {
      holdingUp = true;
    }
    if (keyCode == LEFT) {
      holdingLeft = true;
    }
    if (keyCode == RIGHT) {
      holdingRight = true;
    }
    if (keyCode == DOWN) {
      holdingDown = true;
    }
    if (key == 'r' || key == 'R') { // checking capital too, in case shift or caps lock
      resetProgram();
    }
    /* // reminder: for keys with letters, check "key"
       // instead of "keyCode" ! */
    /*if (key == ' ') { // spacebar
      holdingSpace = true;
    }*/
  }
  void releaseKey() {
    if (keyCode == UP) {
      holdingUp = false;
    }
    if (keyCode == LEFT) {
      holdingLeft = false;
    }
    if (keyCode == RIGHT) {
      holdingRight = false;
    }
    if (keyCode == DOWN) {
      holdingDown = false;
    }
  }
}
