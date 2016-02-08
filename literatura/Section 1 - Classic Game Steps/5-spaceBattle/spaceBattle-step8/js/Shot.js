// shot tuning constants
const SHOT_SPEED = 6.0;
const SHOT_LIFE = 30;
const SHOT_DISPLAY_RADIUS = 2.0;

function shotClass() {
  this.reset = function() {
    this.shotLife = 0;
  }

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
  
  this.shootFrom = function(shipFiring) {
    this.x = shipFiring.x;
    this.y = shipFiring.y;

    this.xv = Math.cos(shipFiring.ang) * SHOT_SPEED + shipFiring.driftX; ////
    this.yv = Math.sin(shipFiring.ang) * SHOT_SPEED + shipFiring.driftY; ////

    this.shotLife = SHOT_LIFE;
  }
  
  this.move = function() {
    if(this.shotLife > 0) {
      this.shotLife--;
    }
    this.x += this.xv; ////
    this.y += this.yv; ////
    this.handleScreenWrap(); ////
  }
  
  this.draw = function() {
    if(this.shotLife > 0) {
      colorCircle( this.x, this.y, SHOT_DISPLAY_RADIUS, 'white' );
    }
  }

} // end of class