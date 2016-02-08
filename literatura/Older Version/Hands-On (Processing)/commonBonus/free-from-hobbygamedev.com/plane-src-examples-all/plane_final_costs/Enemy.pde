class Enemy {
  PImage myImg;
  PVector pos,v;
  int type;
  int animCycle;
  float ang;
  Boolean isAlive;

  static final int TYPE_TANK = 0;
  static final int TYPE_GUY = 1;
  static final int TYPE_HELI = 2;
  
  static final float TANK_SPEED = -0.9;
  static final float GUY_SPEED = -1.26;
  static final float HELI_SPEED = -2.5;
  
  static final int HELI_CRUISE_CEILING = 100;
  static final int HELI_CRUISE_FLOOR = 94;
  
  float mySpeed = 0.0;

  Enemy(float startX, PImage useImg) {
    isAlive = true;
    pos = new PVector(startX, heightAt(int(startX)));
    myImg = useImg;
    
    ang = 0;
    
    if(myImg==tankImg) {
      type = TYPE_TANK;
      mySpeed = TANK_SPEED - random(-0.3,0.3);
    } else if(myImg==guyImg) {
      type = TYPE_GUY;
      mySpeed = GUY_SPEED - random(-0.2,0.2);
    } else {
      type = TYPE_HELI;
      pos.y -= HELI_CRUISE_CEILING;
      mySpeed = HELI_SPEED - random(-0.7,0.7);
    }
    animCycle = 0;
    
    switch(type) {
      case TYPE_TANK:
        v = new PVector(mySpeed,0);
        break;
      case TYPE_GUY:
        v = new PVector(mySpeed,0);
        break;
      case TYPE_HELI:
        v = new PVector(mySpeed,0);
        break;
    }
  }
  
  void handle() {
    int h=0,nextH=0,farH=0;
    
    pos.add(v);
    
    int alphaTrap;
    if(pos.x < 0 || pos.x >= WORLD_SIZE ||
       pos.y < 0) {
      isAlive = false;
    } else {
      int bx=int(pos.x);

      h = heightAt(bx);

      nextH=heightAt(bx-4);

      farH=heightAt(bx-35);
      
      float newAng=0;
      switch(type) {
        case TYPE_TANK:
          if(abs(pos.y-h)<10) {
            pos.y=pos.y*0.8+h*0.2;
          } else {
            pos.y=pos.y*0.6+h*0.4;
          }

          newAng=atan2(nextH-h,-4)+PI;
          if(newAng > PI) {
            newAng-=2*PI;
          }
          ang = 0.9*ang + 0.1*newAng;
          
          v.x = cos(ang)*(mySpeed);
          break;
        case TYPE_GUY:
          if(animCycle--<0) {
            animCycle=2;
            if(myImg==guy_2_Img) {
              myImg = guyImg;
            } else {
              myImg = guy_2_Img;
            }
          }
          
          v.x = cos(atan2(nextH-h,-10)+PI)*(mySpeed);
          
          if(abs(pos.y-h)<10) {
            pos.y=pos.y*0.8+h*0.2;
          } else {
            pos.y=pos.y*0.6+h*0.4;
          }
          break;
        case TYPE_HELI:
          if(animCycle--<0) {
            animCycle=30;
          }
          ang=-0.35*radians(abs(15-animCycle));

          if(pos.y > farH-21) {
            v.x *= 0.8;
            v.y--;
          } else {
            v.x = mySpeed;
            if(pos.y < h-HELI_CRUISE_CEILING) {
              if(v.y<0) {
                v.y=0.0;
              }
              v.y+=0.07;
            } else if(pos.y > h-HELI_CRUISE_FLOOR) {
              if(v.y>0) {
                v.y=0.0;
              }
              v.y-=0.07;
            }
          }
          break;
      }
    }
    
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(ang);
    image(myImg,-myImg.width*0.5,-myImg.height*0.9);
    popMatrix();      
  }

  Boolean finished() {
    return (isAlive==false);
  }
}
