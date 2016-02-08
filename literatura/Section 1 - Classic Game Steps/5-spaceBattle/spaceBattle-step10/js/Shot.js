// shot tuning constants
const SHOT_SPEED = 6.0;
const SHOT_LIFE = 30;
const SHOT_DISPLAY_RADIUS = 2.0;

// setting up the shotClass to inherit from movingWrapPositionClass ////
shotClass.prototype = new movingWrapPositionClass(); ////
// for more complex cases we can capture here a reference to the constructor and superclass ////
// however for now let's just keep things as simple as we can and still have them work :) ////

function shotClass() {
  this.superclassReset = this.reset; ////
  this.reset = function() {
    this.superclassReset(); ////
    this.shotLife = 0;
  }

  //// removed handleScreenWrap since it's defined in movingWrapPositionClass
  
  this.isShotReadyToFire = function() {
    return (this.shotLife <= 0);
  }
  
  this.shootFrom = function(shipFiring) {
    this.x = shipFiring.x;
    this.y = shipFiring.y;

    this.xv = Math.cos(shipFiring.ang) * SHOT_SPEED + shipFiring.xv; //// driftX became xv
    this.yv = Math.sin(shipFiring.ang) * SHOT_SPEED + shipFiring.yv; //// driftY became yv

    this.shotLife = SHOT_LIFE;
  }
  
  this.superclassMove = this.move; // saving a reference to the parent class's move ////
  this.move = function() {
    if(this.shotLife > 0) {
      this.shotLife--;
      this.superclassMove(); ////
    }
  }
  
  this.draw = function() {
    if(this.shotLife > 0) {
      colorCircle( this.x, this.y, SHOT_DISPLAY_RADIUS, 'white' );
    }
  }

} // end of class