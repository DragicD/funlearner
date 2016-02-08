// tuning constants
const SPACESPEED_DECAY_MULT = 0.99; ////
const THRUST_POWER = 0.15; ////
//// removed REVERSE_POWER
const TURN_RATE = 0.03;
//// removed MIN_TURN_SPEED

function shipClass() {
  
  // keyboard hold state variables, to use keys more like buttons
  this.keyHeld_Gas = false;
  //// removed keyHeld_Reverse
  this.keyHeld_TurnLeft = false;
  this.keyHeld_TurnRight = false;

  // key controls used for this
  this.setupControls = function(forwardKey,leftKey,rightKey) { //// removed backKey
    this.controlKeyForGas = forwardKey;
  //// removed keyHeld_Reverse
    this.controlKeyForTurnLeft = leftKey;
    this.controlKeyForTurnRight = rightKey;
  }

  this.init = function(whichGraphic) {
    this.myBitmap = whichGraphic;
    this.reset();
  }
  
  this.reset = function() {
    this.x = canvas.width/2;
    this.y = canvas.height/2;
    this.speed = 0;
    this.ang = -0.5 * Math.PI;
  } // end of reset
  
  this.handleScreenWrap = function() {
    if(this.x < 0) {
      this.x += canvas.width;
    } else if(this.x >= canvas.width) {
      this.x -= canvas.width;
    }

    if(this.y < 0) {
      this.y += canvas.height;
    } else if(this.y >= canvas.height) {
      this.y -= canvas.height;
    }
  }
  
  this.move = function() {
    // only allow turning while it's moving
    //// removed MIN_TURN_SPEED check
    if(this.keyHeld_TurnLeft) {
      this.ang -= TURN_RATE*Math.PI;
    }

    if(this.keyHeld_TurnRight) {
      this.ang += TURN_RATE*Math.PI;
    }
    //// removed close brace for MIN_TURN_SPEED check
    
    if(this.keyHeld_Gas) {
      this.speed += THRUST_POWER; ////
    }
    //// removed keyHeld_Reverse case
    
    this.x += Math.cos(this.ang) * this.speed;
    this.y += Math.sin(this.ang) * this.speed;
    
    this.handleScreenWrap();

    this.speed *= SPACESPEED_DECAY_MULT; ////
  }
  
  this.draw = function() {
    drawBitmapCenteredAtLocationWithRotation( this.myBitmap, this.x, this.y, this.ang );
  }

} // end of class