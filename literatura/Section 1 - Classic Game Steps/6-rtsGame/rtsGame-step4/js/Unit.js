const UNIT_PLACEHOLDER_RADIUS = 5;
const UNIT_PIXELS_MOVE_RATE = 2;

function unitClass() {

  this.reset = function() {
    this.x = Math.random()*canvas.width/4;
    this.y = Math.random()*canvas.height/4;
    this.gotoX = this.x;
    this.gotoY = this.y;
    this.isDead = false;
  }
  
  this.move = function() {
    /* //// this approach would work, and finds the angle if we need it for image rotation
    var deltaX = this.gotoX-this.x; ////
    var deltaY = this.gotoY-this.y; ////
    var moveAng = Math.atan2(deltaY, deltaX); ////
    var moveX = UNIT_PIXELS_MOVE_RATE * Math.cos(moveAng); ////
    var moveY = UNIT_PIXELS_MOVE_RATE * Math.sin(moveAng); ////
    */
    //// this approach skips getting the angle (slightly preferred when we don't need it):
    var deltaX = this.gotoX-this.x; ////
    var deltaY = this.gotoY-this.y; ////
    var distToGo = Math.sqrt(deltaX*deltaX + deltaY*deltaY); ////
    var moveX = UNIT_PIXELS_MOVE_RATE * deltaX/distToGo; ////
    var moveY = UNIT_PIXELS_MOVE_RATE * deltaY/distToGo; ////
    
    if(distToGo > UNIT_PIXELS_MOVE_RATE) { ////
      this.x += moveX; ////
      this.y += moveY; ////
    } else { ////
      this.x = this.gotoX; ////
      this.y = this.gotoY; ////
    } ////
  } // end of move function

  this.draw = function() {
    if(this.isDead == false) {
      colorCircle( this.x, this.y, UNIT_PLACEHOLDER_RADIUS, 'white' );
    }
  }

} // end of class