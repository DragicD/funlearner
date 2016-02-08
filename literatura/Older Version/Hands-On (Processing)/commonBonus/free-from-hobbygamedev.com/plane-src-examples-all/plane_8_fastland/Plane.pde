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
    if(isAlive==false) {
      if(holdingSpace) {
        respawn();
        holdingSpace = false;
      } else {
        return;
      }
    }
    
    if(pos.x<0 || pos.x>=land.width) {
      respawn();
    }

    int h=heightAt(int(pos.x));
    
    alt = h-int(pos.y);
    
    if(alt<0) {
      isAlive=false;
      holdingSpace = false;

      for(int i=0;i<5;i++) {
        shredHole(pos.x+random(-15,15),pos.y+random(-5,15),140,3000);
      }
      
      shredHole(pos.x,pos.y,160,3000);
      shakeAmt+=30.0;
      return;
    }
    
    if(holdingUp) {
      ang += 0.04;
    }
    if(holdingDown) {
      ang -= 0.04;
    }
    if(ang<-PI) {
      ang += 2*PI;
    }
    if(ang>PI) {
      ang -= 2*PI;
    }
    float newSpeed;
    if(holdingRight) {
      newSpeed = maxSpeed;
    } else if(holdingLeft) {
      newSpeed = minSpeed;
    } else {
      newSpeed = avgSpeed;
    }
    
    float downAng = ang-0.5*PI;
    if(downAng<-PI) {
      downAng += 2*PI;
    }
    if(downAng>PI) {
      downAng -= 2*PI;
    }
    
    float downMatters = 1.0-(1100.0-alt)/1100.0;
    if(downMatters>1) {
      downMatters=1;
    }
    downMatters*=downMatters;
    newSpeed *= ((1.0-(abs(downAng)/PI))*downMatters+(1.0-downMatters));

    if(alt>700.0 && ang<0.0) {
      if(ang<-PI*0.5) {
        ang-=0.05;
      } else {
        ang+=0.05;
      }
    }
    
    speed = 0.8*speed+0.2*newSpeed;
    
    if(holdingSpace) {
      if(usedSpace==false) {
        bombList.add(new Bomb());
        usedSpace = true;
      }
    } else {
      usedSpace = false;
    }
    
    v.x = cos(ang)*speed;
    v.y = sin(ang)*speed;
    
    if(speed<5) {
      v.y += 3*(5-speed);
    }
    
    pos.add(v);

    pushMatrix();
    translate(pos.x,pos.y);
    rotate(ang);
    image(planeImg,-planeImg.width*0.5,-planeImg.height*0.5);
    popMatrix();      
  }
}
