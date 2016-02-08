class Player {
  PVector position,velocity; // PVector contains two floats, x and y

  int coinsCollected; // a counter to keep a tally on how many coins the player has collected
  
  static final float RUN_SPEED = 2.5; // force of player movement, in pixels/cycle
  static final float SLOWDOWN_PERC = 0.6; // friction from the ground. multiplied by the x speed each frame.
  
  Player() { // constructor, gets called automatically when the Player instance is created
    position = new PVector();
    velocity = new PVector();
    reset();
  }
  
  void reset() {
    velocity.x = 0;
    velocity.y = 0;
  }
  
  void inputCheck() {
    if(theKeyboard.holdingLeft) {
      velocity.x -= RUN_SPEED;
    } else if(theKeyboard.holdingRight) {
      velocity.x += RUN_SPEED;
    } 
    if(theKeyboard.holdingUp) {
      velocity.y -= RUN_SPEED;
    } else if(theKeyboard.holdingDown) {
      velocity.y += RUN_SPEED;
    } 

    // causes player to constantly lose speed
    // otherwise it would skate around like on ice :)
    velocity.x *= SLOWDOWN_PERC;
    velocity.y *= SLOWDOWN_PERC;
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

    // if any edge of the player is inside a red killblock, reset the round
    if( theWorld.worldSquareAt(topSide)==World.TILE_KILLBLOCK ||
         theWorld.worldSquareAt(leftSide)==World.TILE_KILLBLOCK ||
         theWorld.worldSquareAt(rightSide)==World.TILE_KILLBLOCK ||
         theWorld.worldSquareAt(bottomSide)==World.TILE_KILLBLOCK) {
      resetProgram();
      return; // any other possible collisions would be irrelevant, exit function now
    }
    
    // the following conditionals just check for collisions with each bump probe
    // depending upon which probe has collided, we push the player back the opposite direction
    
    if( theWorld.worldSquareAt(topSide)==World.TILE_SOLID) {
      position.y = theWorld.bottomOfSquare(topSide)+wallProbeDistance;
      if(velocity.y < 0) {
        velocity.y = 0.0;
      }
    }
    
    if( theWorld.worldSquareAt(bottomSide)==World.TILE_SOLID) {
      position.y = theWorld.topOfSquare(bottomSide)-wallProbeDistance;
      if(velocity.y > 0) {
        velocity.y = 0.0;
      }
    }

    if( theWorld.worldSquareAt(leftSide)==World.TILE_SOLID) {
      position.x = theWorld.rightOfSquare(leftSide)+wallProbeDistance;
      if(velocity.x < 0) {
        velocity.x = 0.0;
      }
    }
   
    if( theWorld.worldSquareAt(rightSide)==World.TILE_SOLID) {
      position.x = theWorld.leftOfSquare(rightSide)-wallProbeDistance;
      if(velocity.x > 0) {
        velocity.x = 0.0;
      }
    }
  }

  void checkForCoinGetting() {
    if(theWorld.worldSquareAt(position)==World.TILE_COIN) {
      theWorld.setSquareAtToThis(position, World.TILE_EMPTY);
    }
  }

  void move() {
    position.add(velocity);
    checkForWallBumping();
    checkForCoinGetting();
  }
  
  void draw() {
    int charWidth = mainCharacter.width;
    int charHeight = mainCharacter.height;
    
    pushMatrix(); // lets us compound/accumulate translate/scale/rotate calls, then undo them all at once
    translate(position.x,position.y);
    translate(-charWidth/2,-charHeight/2); // drawing images centered on character
    image(mainCharacter, 0,0);
    popMatrix(); // undoes all translate/scale/rotate calls since the pushMatrix earlier in this function
  }
}

