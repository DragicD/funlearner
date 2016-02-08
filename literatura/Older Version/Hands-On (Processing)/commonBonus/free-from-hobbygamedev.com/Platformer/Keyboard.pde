/* Example Code for Platformer
 * By Chris DeLeon
 * 
 * For more free resources about hobby videogame development, check out:
 * http://www.hobbygamedev.com/
 * 
 * Project compiles in Processing - see Processing.org for more information!
 */

class Keyboard {
  // used to track keyboard input
  Boolean holdingUp,holdingRight,holdingLeft,holdingSpace;
  
  Keyboard() {
    holdingUp=holdingRight=holdingLeft=holdingSpace=false;
  }
  
  /* The way that Processing, and many programming languages/environments, deals with keys is
   * treating them like events (something can happen the moment it goes down, or when it goes up).
   * Because we want to treat them like buttons - checking "is it held down right now?" - we need to
   * use those pressed and released events to update some true/false values that we can check elsewhere.
   */

  void pressKey(int key,int keyCode) {
    if(key == 'r') { // never will be held down, so no Boolean needed to track it
      if(gameWon()) { // if the game has been won...
        resetGame(); // then R key resets it
      }
    }
   
    if (keyCode == UP) {
      holdingUp = true;
    }
    if (keyCode == LEFT) {
      holdingLeft = true;
    }
    if (keyCode == RIGHT) {
      holdingRight = true;
    }
    if (key == ' ') {
      holdingSpace = true;
    }
  }
  void releaseKey(int key,int keyCode) {
    if (keyCode == UP) {
      holdingUp = false;
    }
    if (keyCode == LEFT) {
      holdingLeft = false;
    }
    if (keyCode == RIGHT) {
      holdingRight = false;
    }
    if (keyCode == ' ') {
      holdingSpace = false;
    }
  }
}
