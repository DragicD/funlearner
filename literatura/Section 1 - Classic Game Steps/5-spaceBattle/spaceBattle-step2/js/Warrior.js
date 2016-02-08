// tuning constants
const GROUNDSPEED_DECAY_MULT = 0.94;
const DRIVE_POWER = 0.5;
const REVERSE_POWER = 0.2;
const TURN_RATE = 0.03;
const MIN_TURN_SPEED = 0.5;

function warriorClass() {
  // variables to keep track of position
  this.x = 75;
  this.y = 75;

  // keyboard hold state variables, to use keys more like buttons
  this.keyHeld_Gas = false;
  this.keyHeld_Reverse = false;
  this.keyHeld_TurnLeft = false;
  this.keyHeld_TurnRight = false;

  // key controls used for this
  this.setupControls = function(forwardKey,backKey,leftKey,rightKey) {
    this.controlKeyForGas = forwardKey;
    this.controlKeyForReverse = backKey;
    this.controlKeyForTurnLeft = leftKey;
    this.controlKeyForTurnRight = rightKey;
  }

  this.init = function(whichGraphic) { //// got rid of whichName
    this.myBitmap = whichGraphic;
    //// removed myName, no longer needed since track (and thus finish line) removed
    this.reset();
  }
  
  this.reset = function() {
    this.speed = 0;
    this.ang = -0.5 * Math.PI;
    
    //// removed homeX, homeY, and code that scanned trackGrid for player start
  } // end of reset
  
  this.move = function() {
    // only allow turning while it's moving
    if(Math.abs(this.speed) > MIN_TURN_SPEED) {
      if(this.keyHeld_TurnLeft) {
        this.ang -= TURN_RATE*Math.PI;
      }

      if(this.keyHeld_TurnRight) {
        this.ang += TURN_RATE*Math.PI;
      }
    }
    
    if(this.keyHeld_Gas) {
      this.speed += DRIVE_POWER;
    }
    if(this.keyHeld_Reverse) {
      this.speed -= REVERSE_POWER;
    }
    
    //// removed code from this section that checked for collisions
    this.x += Math.cos(this.ang) * this.speed;
    this.y += Math.sin(this.ang) * this.speed;

    this.speed *= GROUNDSPEED_DECAY_MULT;
  }
  
  this.draw = function() {
    drawBitmapCenteredAtLocationWithRotation( this.myBitmap, this.x, this.y, this.ang );
  }

} // end of class