// tuning constants
const GROUNDSPEED_DECAY_MULT = 0.94;
const DRIVE_POWER = 0.5;
const REVERSE_POWER = 0.2;
const TURN_RATE = 0.03;
const MIN_TURN_SPEED = 0.5;

function shipClass() { //// renamed to ship from Warrior
  //// removed initialization of x and y coord variables here, now in reset function
  
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

  this.init = function(whichGraphic) {
    this.myBitmap = whichGraphic;
    this.reset();
  }
  
  this.reset = function() {
    this.x = canvas.width/2; ////
    this.y = canvas.height/2; ////
    this.speed = 0;
    this.ang = -0.5 * Math.PI;
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
    
    this.x += Math.cos(this.ang) * this.speed;
    this.y += Math.sin(this.ang) * this.speed;

    this.speed *= GROUNDSPEED_DECAY_MULT;
  }
  
  this.draw = function() {
    drawBitmapCenteredAtLocationWithRotation( this.myBitmap, this.x, this.y, this.ang );
  }

} // end of class