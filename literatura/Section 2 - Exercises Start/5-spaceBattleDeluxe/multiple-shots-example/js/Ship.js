// tuning constants
const SPACESPEED_DECAY_MULT = 0.99;
const THRUST_POWER = 0.15;
const TURN_RATE = 0.03;
const PLAYER_RELOAD_DELAY = 8;

// setting up the shipClass to inherit from movingWrapPositionClass
shipClass.prototype = new movingWrapPositionClass();

function shipClass() {
  this.reloadingWait = 0;

  // keyboard hold state variables, to use keys more like buttons
  this.keyHeld_Gas = false;
  this.keyHeld_TurnLeft = false;
  this.keyHeld_TurnRight = false;

  // key controls used for this
  this.setupControls = function(forwardKey,leftKey,rightKey,shotKey) {
    this.controlKeyForGas = forwardKey;
    this.controlKeyForTurnLeft = leftKey;
    this.controlKeyForTurnRight = rightKey;
    this.controlKeyForShotFire = shotKey;
  }

  this.init = function(whichGraphic) {
    this.myShotList = [];
    this.myBitmap = whichGraphic;
    this.reset();
  }

  this.superclassReset = this.reset;
  this.reset = function() { 
    this.superclassReset();    
    this.x = canvas.width/2;
    this.y = canvas.height/2;
    this.ang = -0.5 * Math.PI;
    this.myShotList = [];
  } // end of reset
  
  this.cannonFire = function() {
    if(this.reloadingWait <= 0) {
      var nextShot = new shotClass();
      nextShot.shootFrom(this);
      this.myShotList.push(nextShot);
      this.reloadingWait = PLAYER_RELOAD_DELAY;
    }
  }
  
  this.checkMyShipAndShotCollisionAgainst = function(thisEnemy) {
    if( thisEnemy.isOverlappingPoint(this.x,this.y) ) {
      this.reset();
      document.getElementById("debugText").innerHTML = "Player Crashed!";
    }
    for(var i=0;i<this.myShotList.length;i++) {
      if( this.myShotList[i].hitTest(thisEnemy) ) {
        thisEnemy.reset();
        this.myShotList[i].markToRemove();
        document.getElementById("debugText").innerHTML = "Enemy Blasted!";
      }
    }
  }
  
  this.superclassMove = this.move; // saving a reference to the parent class's move
  this.move = function() {
    // only allow turning while it's moving
    if(this.keyHeld_TurnLeft) {
      this.ang -= TURN_RATE*Math.PI;
    }

    if(this.keyHeld_TurnRight) {
      this.ang += TURN_RATE*Math.PI;
    }
    
    if(this.keyHeld_Gas) {
      this.xv += Math.cos(this.ang) * THRUST_POWER;
      this.yv += Math.sin(this.ang) * THRUST_POWER;
    }
    
    this.superclassMove();

    this.xv *= SPACESPEED_DECAY_MULT;
    this.yv *= SPACESPEED_DECAY_MULT;

    this.shotsAndReloadUpdate();
  }

  this.shotsAndReloadUpdate = function() {
    if(this.reloadingWait > 0) {
      this.reloadingWait--;
    }
    for(var i=0;i<this.myShotList.length;i++) {
      this.myShotList[i].move();
    }
    for(var i=this.myShotList.length-1; i>=0; i--) {
      if(this.myShotList[i].isReadyToRemove()) {
        this.myShotList.splice(i,1);
        // console.log(this.myShotList.length); // shows that all elements get removed
      }
    }
  }
  
  this.draw = function() {
    for(var i=0;i<this.myShotList.length;i++) {
      this.myShotList[i].draw();
    }
    
    drawBitmapCenteredAtLocationWithRotation( this.myBitmap, this.x, this.y, this.ang );
  }

} // end of class