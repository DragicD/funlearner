class Unit {
  final float MOVE_SPEED = 1.5;
  final float ATTACK_RANGE = 30.0;
  final int START_HEALTH = 4;
  
  final int MIN_RELOAD_FRAMES = 10;
  final int MAX_RELOAD_FRAMES = 15;

  final int MIN_AI_RETHINK_FRAMES = 24;
  final int MAX_AI_RETHINK_FRAMES = 70;
  
  final int MIN_AI_WANDER_RANGE = 35; // in pixels
  final int MAX_AI_WANDER_RANGE = 100;
  
  final int MIN_DODGE_RANGE = 10; // in pixels
  final int MAX_DODGE_RANGE = 20;
  
  final int MARGIN = 10;
  final int AI_MOOD_WANDER = 0;
  final int AI_MOOD_ATTACK = 1;
  final int AI_MOOD_TYPES = 2;
  final float AI_TARGET_RANGE = ATTACK_RANGE*4.0;
  
  float meX,meY;
  float gotoX,gotoY;
  int framesReloadTime;
  int hitpoints;
  int frames_AI_Rethink;
  boolean isDead = false;
  boolean isAttacking;
  boolean playerTeam;
  int aiMood;
  Unit target;
  Unit targetBetweenDodge;

  void randomReset() {
    meX = (int)random(width*0.25);
    meY = (int)random(height*0.25);
    // put 70% of soldiers on AI team, so player has to use strategy 
    playerTeam = (random(100)<30);
    targetBetweenDodge = null;
    if(playerTeam == false) { // start AI in opposite corner
      meX += width*0.75-MARGIN;
      meY += height*0.75-MARGIN;
    } else {
      meX += MARGIN;
      meY += MARGIN;
    }
    gotoX = meX;
    gotoY = meY;
    hitpoints = START_HEALTH;
    frames_AI_Rethink = 0;
    isDead = false;
    isAttacking = false;
    target = null;
  }

  Unit() {
    randomReset();
  }
  
  void damage(Unit fromUnit) {
    hitpoints--;
    if(hitpoints <= 0) {
      isDead = true;
      isAttacking = false;
      target = null;
    } else if(target == null) {
      target = fromUnit;
    }
  }
  
  void boundsCheck() {
    if(gotoX < MARGIN) {
      gotoX = MARGIN;
    }
    if(gotoX > width-MARGIN) {
      gotoX = width-MARGIN;
    }
    if(gotoY < MARGIN) {
      gotoY = MARGIN;
    }
    if(gotoY > height-MARGIN) {
      gotoY = height-MARGIN;
    }
  }
  
  void attackIfInRange() {
    if(isAttacking || target!=null) {
      return; // already ordered to attack? don't change target
    }
    if(meX!=gotoX || meY!=gotoY) {
      return; // following orders to move - don't override orders
    }
    for(int i=0;i<units.size();i++) {
      Unit eachUnit = (Unit)units.get(i);
      if(eachUnit.isDead == false &&
            eachUnit.playerTeam !=playerTeam && 
            dist(meX,meY,eachUnit.meX,eachUnit.meY) <
                                      ATTACK_RANGE) {
        target = eachUnit;
        break; // a target was found in range, quit looking
      }
    }
  }
  
  void aiUpdate() {
    frames_AI_Rethink--;
    if(frames_AI_Rethink <= 0) {
      aiMood = (int)random(AI_MOOD_TYPES);
      frames_AI_Rethink = (int)random(MIN_AI_RETHINK_FRAMES,
                                 MAX_AI_RETHINK_FRAMES);
      switch(aiMood) {
        case AI_MOOD_WANDER:
          float distWander = random(MIN_AI_WANDER_RANGE,
                                    MAX_AI_WANDER_RANGE);   
          float angTo = random(PI*2.0);
          gotoX = meX + cos(angTo)*distWander;
          gotoY = meY + sin(angTo)*distWander;
          boundsCheck();
          break;
        case AI_MOOD_ATTACK:
          for(int i=0;i<units.size();i++) {
            Unit eachUnit = (Unit)units.get(i);
            if(eachUnit.isDead == false &&
               eachUnit.playerTeam && 
               dist(meX,meY,eachUnit.meX,eachUnit.meY) <
                                            AI_TARGET_RANGE) {
              target = eachUnit;
              break; // a target was found in range, quit looking
            }
          }
          break;
      } // end of switch
    } // end of AI rethink time
  } // end of ai function
  
  void moveMe() {
    if(isDead) {
      return;
    }
    
    if(playerTeam == false) {
      aiUpdate();
    }
    
    attackIfInRange();
    
    isAttacking = false;
    if(target != null) {
      if(target.isDead) {
        target = null;
        gotoX = meX;
        gotoY = meY;
      } else {
        float deltaX = target.meX-meX;
        float deltaY = target.meY-meY;
        float distFromEnemy = dist(meX,meY,
                              target.meX,target.meY);
        if(distFromEnemy <= ATTACK_RANGE) {
          isAttacking = true;
          gotoX = meX;
          gotoY = meY;
        } else {
          gotoX = target.meX-0.95*ATTACK_RANGE*deltaX/distFromEnemy;
          gotoY = target.meY-0.95*ATTACK_RANGE*deltaY/distFromEnemy;
        }
      }
    }
    
    framesReloadTime--;
    if(isAttacking) {
       if(framesReloadTime <= 0) {
         framesReloadTime = (int)random(MIN_RELOAD_FRAMES,MAX_RELOAD_FRAMES);
         target.damage(this);
         float distDodge = random(MIN_DODGE_RANGE,
                                  MAX_DODGE_RANGE);   
         float angTo = random(PI*2.0);
         gotoX = meX + cos(angTo)*distDodge;
         gotoY = meY + sin(angTo)*distDodge;
         targetBetweenDodge = target;
         target = null;
         boundsCheck();
       }
    }
    
    // using trig to move straight toward target destination
    float distToGo = dist(meX,meY,gotoX,gotoY);
    if(distToGo > MOVE_SPEED) {
      float angTo = atan2(gotoY-meY,gotoX-meX);
      meX += cos(angTo)*MOVE_SPEED;
      meY += sin(angTo)*MOVE_SPEED;
    } else { // lock in position, checked elsewhere to know if moving
      meX = gotoX;
      meY = gotoY;
      if(targetBetweenDodge != null) {
        target = targetBetweenDodge;
        targetBetweenDodge = null;
      }
    }
    // commented out below is how to avoid trig by instead doing
    // simple comparisons though then it doesn't move straight to
    // the target and moves faster diagonally than along an axis
    /*
    if(meX<gotoX-MOVE_SPEED) {
      meX += MOVE_SPEED;
    }
    if(meX>gotoX+MOVE_SPEED) {
      meX -= MOVE_SPEED;
    }
    if(meY<gotoY-MOVE_SPEED) {
      meY += MOVE_SPEED;
    }
    if(meY>gotoY+MOVE_SPEED) {
      meY -= MOVE_SPEED;
    }*/
  }
  
  void gotoMouse(int formationPosition,int formationDim) {
    int rowNum = formationPosition / formationDim;
    int colNum = formationPosition % formationDim;
    gotoX = mouseX + 10.0f*colNum;
    gotoY = mouseY + 10.0f*rowNum;
    boundsCheck();
    target = null;
  }
  
  void mouseCheck() {
    if(isDead==false && 
        dist(meX,meY,mouseX,mouseY) < SELECTOR_RANGE) {
      newSelection = this;
    }
  }
  
  boolean isInLasso() {
    return (meX<lassoX1 ||
            meX>lassoX2 ||
            meY<lassoY1 ||
            meY>lassoY2) == false;
  }
  
  void showHealth() {
    stroke(0,0,0,160);
    for(int i=0;i<START_HEALTH;i++) {
      if(hitpoints>i) {
        fill(255,255,0);
      } else {
        fill(0,0,0);
      }
      rect(meX-7+i*3,meY-8,3,3);
    }
  }
  
  void showSelectionBox() {
    noFill();
    stroke(0,0,0);
    rect(meX-10,meY-10,20,20);
  }
  
  void drawDead() {
    if(playerTeam) {
      fill(255,220,0);
    } else {
      fill(255,0,220);
    }
    rect(meX-3,meY-2,6,4);
  }
  
  void drawMe() {
    stroke(0,0,0);
    showHealth();
    if(playerTeam) {
      fill(255,190,50);
    } else {
      fill(255,50,190);
    }
    
    rect(meX-4,meY-4,8,8);
    
    if(target != null) {
      if(isAttacking) {
        stroke(255,120,0);
      } else {
        stroke(100,100,100);
      }
      line(meX,meY,target.meX,target.meY);
    }
  }
}
