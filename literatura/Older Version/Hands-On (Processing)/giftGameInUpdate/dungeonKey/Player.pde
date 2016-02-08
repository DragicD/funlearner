class Player {
  PVector position; // PVector contains two floats, x and y

  int keysCollected; // a counter to keep a tally on how many keys the player has collected
  
  boolean facingLeft = false;
  
  static final float MOVESPEED = 3.0;
  
  Player() { // constructor, gets called automatically when the Player instance is created
    position = new PVector();
    reset();
  }
  
  void reset() {
  }
  
  void inputCheck() {
    if(theKeyboard.holdingLeft) {
      position.x -= MOVESPEED;
      facingLeft = true;
    } else if(theKeyboard.holdingRight) {
      position.x += MOVESPEED;
      facingLeft = false;
    } 
    if(theKeyboard.holdingUp) {
      position.y -= MOVESPEED;
    } else if(theKeyboard.holdingDown) {
      position.y += MOVESPEED;
    }
  }
  
  boolean CantPassThisPointThoughUseKeyIfNeeded(PVector thisLocation) {
    if( theWorld.worldSquareAt(thisLocation)==World.TILE_SOLID ) {
      return true;
    }
    // no need for else, since above quits the function upon hitting the "return" line
    if( theWorld.worldSquareAt(thisLocation)==World.TILE_DOOR ) {
      if(keysCollected > 0) { // have keys?
        keysCollected--; // decrease number of keys available
        theWorld.setSquareAtToThis(thisLocation, World.TILE_EMPTY); // remove door
        return false; // let us pass through it
      } else {
        return true; // no keys available, so door blocks path
      }
    }
    return false; // not a wall nor a locked door, so let us pass through/over it
  }
  
  void checkForWallBumping() {
    int guyWidth = mainCharacter.width; // basing "physical" size on image size
    int wallProbeDistance = int(guyWidth*0.5);
    
    /* Because of how we draw the player, "position" is the center of the image
     * To detect and handle wall collisions, we create 4 relative positions:
     * leftSide - left of center
     * rightSide - right of center
     * topSide - center of top
     * bottomSide - center of bottom
     */
    
    // used as probes to detect running into walls, ceiling
    PVector leftSide,rightSide,topSide,bottomSide;
    leftSide = new PVector();
    rightSide = new PVector();
    topSide = new PVector();
    bottomSide = new PVector();

    // update wall probe coordinates
    topSide.x = bottomSide.x = position.x;
    leftSide.x = position.x - wallProbeDistance; // left edge of player
    rightSide.x = position.x + wallProbeDistance; // left edge of player
    
    leftSide.y = rightSide.y = position.y;
    topSide.y = position.y - wallProbeDistance; // top edge of player
    bottomSide.y = position.y + wallProbeDistance; // bottom edge of player

    // if any edge of the player is inside a red goalblock, reset the round
    if( theWorld.worldSquareAt(topSide)==World.TILE_GOALBLOCK ||
         theWorld.worldSquareAt(leftSide)==World.TILE_GOALBLOCK ||
         theWorld.worldSquareAt(rightSide)==World.TILE_GOALBLOCK ||
         theWorld.worldSquareAt(bottomSide)==World.TILE_GOALBLOCK) {
      resetProgram();
      return; // any other possible collisions would be irrelevant, exit function now
    }
    
    // the following conditionals just check for collisions with each bump probe
    // depending upon which probe has collided, we push the player back the opposite direction
    
    if( CantPassThisPointThoughUseKeyIfNeeded(topSide) ) {
      position.y = theWorld.bottomOfSquare(topSide)+wallProbeDistance;
    }
    
    if( CantPassThisPointThoughUseKeyIfNeeded(bottomSide) ) {
      position.y = theWorld.topOfSquare(bottomSide)-wallProbeDistance;
    }

    if( CantPassThisPointThoughUseKeyIfNeeded(leftSide) ) {
      position.x = theWorld.rightOfSquare(leftSide)+wallProbeDistance;
    }
   
    if( CantPassThisPointThoughUseKeyIfNeeded(rightSide) ) {
      position.x = theWorld.leftOfSquare(rightSide)-wallProbeDistance;
    }
  }

  void checkForKeyGetting() {
    if(theWorld.worldSquareAt(position)==World.TILE_KEY) {
      keysCollected++;
      theWorld.setSquareAtToThis(position, World.TILE_EMPTY);
    }
  }

  void move() {
    inputCheck();
    checkForWallBumping();
    checkForKeyGetting();
  }
  
  void draw() {
    int charWidth = mainCharacter.width;
    int charHeight = mainCharacter.height;
    
    pushMatrix(); // lets us compound/accumulate translate/scale/rotate calls, then undo them all at once
    translate(position.x,position.y);
    if(facingLeft) { // flip horizontally if facing left
      scale(-1.0,1.0);
    }
    translate(-charWidth/2,-charHeight/2); // drawing images centered on character
    image(mainCharacter, 0,0);
    popMatrix(); // undoes all translate/scale/rotate calls since the pushMatrix earlier in this function
  }
}

