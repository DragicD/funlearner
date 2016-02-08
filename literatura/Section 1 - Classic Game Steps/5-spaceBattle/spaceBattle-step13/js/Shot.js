// shot tuning constants
const SHOT_SPEED = 6.0;
const SHOT_LIFE = 30;
const SHOT_DISPLAY_RADIUS = 2.0;

// setting up the shotClass to inherit from movingWrapPositionClass
shotClass.prototype = new movingWrapPositionClass();

function shotClass() {
  this.superclassReset = this.reset;
  this.reset = function() {
    this.superclassReset();
    this.shotLife = 0;
  }

  this.isShotReadyToFire = function() {
    return (this.shotLife <= 0);
  }
  
  this.shootFrom = function(shipFiring) {
    this.x = shipFiring.x;
    this.y = shipFiring.y;

    this.xv = Math.cos(shipFiring.ang) * SHOT_SPEED + shipFiring.xv;
    this.yv = Math.sin(shipFiring.ang) * SHOT_SPEED + shipFiring.yv;

    this.shotLife = SHOT_LIFE;
  }
  
  this.hitTest = function(thisEnemy) {
    if(this.shotLife <= 0) {
      return false;
    }
    return thisEnemy.isOverlappingPoint(this.x,this.y);
  }
  
  this.superclassMove = this.move; // saving a reference to the parent class's move
  this.move = function() {
    if(this.shotLife > 0) {
      this.shotLife--;
      this.superclassMove();
    }
  }
  
  this.draw = function() {
    if(this.shotLife > 0) {
      colorCircle( this.x, this.y, SHOT_DISPLAY_RADIUS, 'white' );
    }
  }

} // end of class