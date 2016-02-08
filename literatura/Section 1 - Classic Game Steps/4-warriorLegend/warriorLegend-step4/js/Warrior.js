// tuning constants //// removed the word "car"
const GROUNDSPEED_DECAY_MULT = 0.94;
const DRIVE_POWER = 0.5;
const REVERSE_POWER = 0.2;
const TURN_RATE = 0.03;
const MIN_TURN_SPEED = 0.5;

function warriorClass() {
  // variables to keep track of position //// removed the word "car"
  this.x = 75; //// removed the word "car"
  this.y = 75; //// removed the word "car"

  // keyboard hold state variables, to use keys more like buttons
  this.keyHeld_Gas = false;
  this.keyHeld_Reverse = false;
  this.keyHeld_TurnLeft = false;
  this.keyHeld_TurnRight = false;

  // key controls used for this //// removed the word "car" 
  this.setupControls = function(forwardKey,backKey,leftKey,rightKey) {
    this.controlKeyForGas = forwardKey;
    this.controlKeyForReverse = backKey;
    this.controlKeyForTurnLeft = leftKey;
    this.controlKeyForTurnRight = rightKey;
  }

  this.init = function(whichGraphic,whichName) { //// removed the word "car"
    this.myBitmap = whichGraphic;
    this.myName = whichName;
    this.reset(); //// removed the word "car"
  }
  
  this.reset = function() { //// removed the word "car"
    this.speed = 0; //// removed the word "car"
    this.ang = -0.5 * Math.PI; //// removed the word "car"
  
    if(this.homeX == undefined) {
      for(var i=0; i<trackGrid.length; i++) {
        if( trackGrid[i] == TRACK_PLAYER) {
          var tileRow = Math.floor(i/TRACK_COLS);
          var tileCol = i%TRACK_COLS;
          this.homeX = tileCol * TRACK_W + 0.5*TRACK_W;
          this.homeY = tileRow * TRACK_H + 0.5*TRACK_H;
          trackGrid[i] = TRACK_ROAD;
          break; // found it, so no need to keep searching 
        } // end of if
      } // end of for
    } // end of if position not saved yet //// removed the word "car"
    
    this.x = this.homeX; //// removed the word "car"
    this.y = this.homeY; //// removed the word "car"

  } // end of reset //// removed the word "car"
  
  this.move = function() { //// removed the word "car"
    // only allow turning while it's moving //// removed the word "car"
    if(Math.abs(this.speed) > MIN_TURN_SPEED) { //// removed the word "car"
      if(this.keyHeld_TurnLeft) {
        this.ang -= TURN_RATE*Math.PI; //// removed the word "car"
      }

      if(this.keyHeld_TurnRight) {
        this.ang += TURN_RATE*Math.PI; //// removed the word "car"
      }
    }
    
    if(this.keyHeld_Gas) {
      this.speed += DRIVE_POWER; //// removed the word "car"
    }
    if(this.keyHeld_Reverse) {
      this.speed -= REVERSE_POWER; //// removed the word "car"
    }
    
    var nextX = this.x + Math.cos(this.ang) * this.speed; //// removed the word "car" x3
    var nextY = this.y + Math.sin(this.ang) * this.speed; //// removed the word "car" x3
    
    var drivingIntoTileType = getTrackAtPixelCoord(nextX,nextY);
    
    if( drivingIntoTileType == TRACK_ROAD ) {
      this.x = nextX; //// removed the word "car"
      this.y = nextY; //// removed the word "car"
    } else if( drivingIntoTileType == TRACK_GOAL ) {
      document.getElementById("debugText").innerHTML = this.myName + " won the race";
      this.reset(); //// removed the word "car"
    } else {
      this.speed = 0.0; //// removed the word "car"
    }

    this.speed *= GROUNDSPEED_DECAY_MULT; //// removed the word "car"
  }
  
  this.draw = function() { //// removed the word "car"
    //// removed the word "car" x3
    drawBitmapCenteredAtLocationWithRotation( this.myBitmap, this.x, this.y, this.ang );
  }

} // end of class //// removed the word "car"