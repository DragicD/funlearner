class Enemy {
  PVector pos;
  int animCycle;
  float ang;
  Boolean isAlive;

  static final float TANK_SPEED = -0.9;

  Enemy() {
    isAlive = true;
    pos = new PVector(land.width-2, heightAt(land.width-2));
    
    ang = 0;
    
    animCycle = 0;
  }
  
  void handle() {
    int h=0,nextH=0;
    
    int alphaTrap;
    if(pos.x < 0 || pos.x >= land.width ||
       pos.y < 0) {
      isAlive = false;
    } else {
      int bx=int(pos.x);

      h = heightAt(bx);

      nextH=heightAt(bx-4);      
      float newAng=0;

      // soften vertical change, to smooth out moving over rough bumpy land
      if(abs(pos.y-h)<10) { // major height shift of 10 pixels or more?
        pos.y=pos.y*0.8+h*0.2; // less smooth, so it doesn't seem too floaty
      } else {
        pos.y=pos.y*0.6+h*0.4; // a bit smoother, since the change isn't as dramatic
      }
      
      newAng=atan2(nextH-h,-4)+PI;
      if(newAng > PI) {
        newAng-=2*PI;
      }
      ang = 0.9*ang + 0.1*newAng; // smooth out angle changes, too
      
      pos.x += cos(ang)*(TANK_SPEED); // base speed on incline steepness
    }
    
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(ang);
    image(tankImg,-tankImg.width*0.5,-tankImg.height*0.9);
    popMatrix();      
  }

  Boolean finished() {
    return (isAlive==false);
  }
}
