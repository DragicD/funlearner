class Enemy {
  float ai_x;
  float ai_y;
  float ai_speed;
  int timeTilTrackingUpdate;
  int toX,toY;
  boolean isWandering;

  Enemy() {
    ai_x = random(width);
    ai_y = random(height);
    ai_speed = 0.5+random(4.0);
    timeTilTrackingUpdate = 0;
    isWandering = false;
  }

  float findDist(float x1,float y1, float x2,float y2)
  {
    float xdiff = x2-x1;
    float ydiff = y2-y1;
    return sqrt(xdiff*xdiff + ydiff*ydiff);
  }

  void moveAI() {
    /*if( findDist(ai_x,ai_y, toX,toY) < 2*ai_speed) {
      timeTilTrackingUpdate = 0;
    }*/
    
    timeTilTrackingUpdate -= deltaMS;
    if(timeTilTrackingUpdate <= 0) {
      timeTilTrackingUpdate = 300+(int)random(1300);
      isWandering = ( random(100)<35 );
      if(isWandering) {
        toX = (int)random(width);
        toY = (int)random(height);
      } else {
        toX = mouseX;
        toY = mouseY;
      }
    }
    
    if(ai_x < toX) {
      ai_x += ai_speed;
    }
    if(ai_x > toX) {
      ai_x -= ai_speed;
    }
    if(ai_y < toY) {
      ai_y += ai_speed;
    }
    if(ai_y > toY) {
      ai_y -= ai_speed;
    }
  }
  
  void drawAI() {
    if(isWandering) {
      fill(255,255,0);
    } else {
      fill(255,0,0);
    }
    rect(ai_x-10, ai_y-10, 20,20);
  }
}

