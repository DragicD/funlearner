// tuning constants
const SPACESPEED_DECAY_MULT = 0.99;
const THRUST_POWER = 0.15;
const TURN_RATE = 0.03;

function shipClass() {
  
  // keyboard hold state variables, to use keys more like buttons
  this.keyHeld_Gas = false;
  this.keyHeld_TurnLeft = false;
  this.keyHeld_TurnRight = false;

  // key controls used for this
  this.setupControls = function(forwardKey,leftKey,rightKey,shotKey) { ////
    this.controlKeyForGas = forwardKey;
    this.controlKeyForTurnLeft = leftKey;
    this.controlKeyForTurnRight = rightKey;
    this.controlKeyForShotFire = shotKey; ////
  }

  this.init = function(whichGraphic) {
    this.myShot = new shotClass(); ////
    this.myBitmap = whichGraphic;
    this.reset();
  }

  this.reset = function() {  
    this.driftX = this.driftY = 0.0;
    this.x = canvas.width/2;
    this.y = canvas.height/2;
    this.ang = -0.5 * Math.PI;
    this.myShot.reset(); ////
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
  
  this.cannonFire = function() { ////
    this.myShot.shootFrom(this); ////
  } ////
  
  this.move = function() {
    // only allow turning while it's moving
    if(this.keyHeld_TurnLeft) {
      this.ang -= TURN_RATE*Math.PI;
    }

    if(this.keyHeld_TurnRight) {
      this.ang += TURN_RATE*Math.PI;
    }
    
    if(this.keyHeld_Gas) {
      this.driftX += Math.cos(this.ang) * THRUST_POWER;
      this.driftY += Math.sin(this.ang) * THRUST_POWER;
    }
    
    this.x += this.driftX;
    this.y += this.driftY;
    
    this.handleScreenWrap();

    this.driftX *= SPACESPEED_DECAY_MULT;
    this.driftY *= SPACESPEED_DECAY_MULT;

    this.myShot.move(); ////
  }
  
  this.draw = function() {
    this.myShot.draw(); ////
    
    drawBitmapCenteredAtLocationWithRotation( this.myBitmap, this.x, this.y, this.ang );
  }

} // end of class