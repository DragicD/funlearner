class Plane {
  PVector pos,v;
  float ang;
  float alt;
  Boolean isAlive;
  
  Boolean usedSpace;
  
  final int startY = 300;
  final int reloadClickInterval = 4;
  final float minSpeed = 8.0*0.7;
  final float avgSpeed = 12.5*0.7;
  final float maxSpeed = 17.5*0.7;
  
  float speed = avgSpeed;
  
  Plane() {
    pos = new PVector(0, startY);
    v = new PVector(speed,0);
    respawn();
  }
  
  void respawn() {
    isAlive = true;
    pos.x = 0;
    pos.y = startY;
    speed = avgSpeed;
    v.x = speed;
    v.y = 0;
    usedSpace = false;
    ang = 0;
    cameraOffsetX = 0;
  }
  
  void handle() {
    if(isAlive==false) { // is the plane crashed?
      if(holdingSpace) { // pressing space?
        respawn(); // reset the plane
        
        // so that the bomb button doesn't fire after respawn
        holdingSpace = false;
        usedSpace = true;
      } else {
        return;
      }
    }
    
    // off left or right edge of the world?
    if(pos.x<0 || pos.x>=land.width) {
      respawn();
    }

    int h=heightAt(int(pos.x));
    
    alt = h-int(pos.y); // getting the plane's altitude above the ground
    
    if(alt<0) { // plane is under 0 altitude means that it crashed
      isAlive=false; // hides the plane until reset
      
      holdingSpace = false; // so that holding the bomb button doesn't cause instant respawn

      for(int i=0;i<5;i++) { // rips up 5 holes nearby in the ground
        shredHole(pos.x+random(-15,15),pos.y+random(-5,15),140,3000);
      }
      
      shredHole(pos.x,pos.y,160,3000); // puts a big hole in the ground
      shakeAmt+=30.0; // shakes the camera violently
      return;
    }
    
    if(holdingUp) { // joystick diving?
      ang += 0.04;
    }
    if(holdingDown) { // joystick pulling up?
      ang -= 0.04;
    }
    
    // keep plane's angle in a manageable domain for easier smoothing
    if(ang<-PI) {
      ang += 2*PI;
    }
    if(ang>PI) {
      ang -= 2*PI;
    }
    float newSpeed;
    
    if(holdingRight) { // holding down max throttle?
      newSpeed = maxSpeed;
    } else if(holdingLeft) { // holding down min throttle?
      newSpeed = minSpeed;
    } else { // cruising
      newSpeed = avgSpeed;
    }
    
    float downAng = ang-0.5*PI; // minus 90 degrees, so it's in relation to pointing upward
    
    // these next two operations put the angle into a consistent domain for easier smoothing
    if(downAng<-PI) {
      downAng += 2*PI;
    }
    if(downAng>PI) {
      downAng -= 2*PI;
    }
    
    float downMatters = 1.0-(1100.0-alt)/1100.0; // faking importance of the plane angle to speed
    if(downMatters>1) { // capping it at 100% influence on throttle
      downMatters=1;
    }
    downMatters *= downMatters; // square the effect
    newSpeed *= ((1.0-(abs(downAng)/PI))*downMatters+(1.0-downMatters)); // dive angle affect on speed

    // above 700 units high, and still pointing upward?
    if(alt>700.0 && ang<0.0) {
      if(ang<-PI*0.5) { // if mostly leaning back, lean back further
        ang-=0.05;
      } else { // otherwise, learn further forward
        ang+=0.05;
      }
    }
    
    speed = 0.8*speed+0.2*newSpeed; // smooth speed change
    
    if(holdingSpace) { // was spacebar pressed?
      if(usedSpace==false) { // have we used it yet to drop a bomb?
        bombList.add(new Bomb()); // add the new bomb
        usedSpace = true; // mark it as used
      }
    } else {
      usedSpace = false; // mark it as free, ready to be pressed again
    }
    
    // updating velocity based on plane's angle
    v.x = cos(ang)*speed;
    v.y = sin(ang)*speed;
    
    if(speed<5) { // going too slow? lose altitude.
      v.y += 3*(5-speed);
    }
    
    pos.add(v); // adding velocity to the plane's position

    // drawing the plane
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(ang);
    image(planeImg,-planeImg.width*0.5,-planeImg.height*0.5);
    popMatrix();      
  }
}
