class Unit {
  final float FORMATION_PIXEL_SPACING = 15.0f;
  final int SELECTION_BOX_SIZE = 30;
  final int HEALTH_SHOW_RANGE = 60;
  
  final float MOVE_SPEED_INFANTRY = 1.5;
  final float MOVE_SPEED_ROBOT = 0.7;
  float moveSpeed;

  final float ATTACK_RANGE_INFANTRY = 45.0;
  final float ATTACK_RANGE_ROBOT = 180.0;
  float attackRange;

  final int START_HEALTH_INFANTRY = 4;
  final int START_HEALTH_ROBOT = 16;
  int startHealth;
  
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
  float AI_TargetRange;
  
  float meX,meY;
  float gotoX,gotoY;
  int framesReloadTime;
  int hitpoints;
  int frames_AI_Rethink;
  boolean isDead = false;
  boolean isAttacking;
  boolean playerTeam;
  boolean isHeavy;
  int aiMood;
  Unit target;
  Unit targetBetweenDodge;

  void randomReset() {
    meX = (int)random(width*0.25);
    meY = (int)random(height*0.25);
    // put 70% of soldiers on AI team, so player has to use strategy 
    playerTeam = (random(100)<30);
    isHeavy = (random(100)<8);
    
    if(isHeavy) {
      moveSpeed = MOVE_SPEED_ROBOT;
      attackRange = ATTACK_RANGE_ROBOT;
      startHealth = START_HEALTH_ROBOT;
    } else {
      moveSpeed = MOVE_SPEED_INFANTRY;
      attackRange = ATTACK_RANGE_INFANTRY;
      startHealth = START_HEALTH_INFANTRY;
    }
    
    AI_TargetRange = attackRange*4.0;
    
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
    hitpoints = startHealth;
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
                                      attackRange) {
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
                                            AI_TargetRange) {
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
        if(distFromEnemy <= attackRange) {
          isAttacking = true;
          gotoX = meX;
          gotoY = meY;
        } else {
          gotoX = target.meX-0.95*attackRange*deltaX/distFromEnemy;
          gotoY = target.meY-0.95*attackRange*deltaY/distFromEnemy;
        }
      }
    }
    
    framesReloadTime--;
    if(isAttacking) {
       if(framesReloadTime <= 0) {
         framesReloadTime = (int)random(MIN_RELOAD_FRAMES,
                                         MAX_RELOAD_FRAMES);
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
    if(distToGo > moveSpeed) {
      float angTo = atan2(gotoY-meY,gotoX-meX);
      meX += cos(angTo)*moveSpeed;
      meY += sin(angTo)*moveSpeed;
    } else { // lock in position, checked elsewhere to know if moving
      meX = gotoX;
      meY = gotoY;
      if(targetBetweenDodge != null) {
        target = targetBetweenDodge;
        targetBetweenDodge = null;
      }
    }
  }
  
  void gotoMouse(int formationPosition,int formationDim) {
    int rowNum = formationPosition / formationDim;
    int colNum = formationPosition % formationDim;
    gotoX = mouseX + FORMATION_PIXEL_SPACING*colNum;
    gotoY = mouseY + FORMATION_PIXEL_SPACING*rowNum;
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
    noStroke();
    float pixelSkipWidth = 3.0*4.0/startHealth;
    for(int i=0;i<startHealth;i++) {
      if(hitpoints>i) {
        if(hitpoints==startHealth) {
          fill(0,255,0);
        } else if(hitpoints<=startHealth/2) {
          fill(255,0,0);
        } else {
          fill(255,255,0);
        }
      } else {
        fill(0,0,0);
      }
      rect(meX-7+i*pixelSkipWidth,meY-11,pixelSkipWidth,3);
    }
  }
  
  void showSelectionBox() {
    noFill();
    stroke(0,0,0,90);
    rect(meX-SELECTION_BOX_SIZE/2,meY-SELECTION_BOX_SIZE/2,
        SELECTION_BOX_SIZE,SELECTION_BOX_SIZE);
  }
  
  void drawDead() {
    if(playerTeam) {
      tint(255,220,0);
    } else {
      tint(255,0,220);
    }
    
    PImage useImage;
    if(isHeavy) {
      useImage = img_infantry_heavy_off;
    } else {
      useImage = img_infantry_off;
    }
    image(useImage,meX-useImage.width/2,
                       meY-useImage.height/2);
    
    tint(255,255,255); // restore default white/non tint
  }
  
  void drawMe() {
    stroke(0,0,0);
    
    if(dist(mouseX,mouseY,meX,meY) < HEALTH_SHOW_RANGE) {
      showHealth();
    }
    
    if(playerTeam) {
      tint(255,190,50);
    } else {
      tint(255,50,190);
    }
    
    PImage useImage;
    if(isHeavy) {
      useImage = img_infantry_heavy;
    } else {
      useImage = img_infantry;
    }
    image(useImage,meX-useImage.width/2,
                       meY-useImage.height/2);
    
    tint(255,255,255); // restore default white/non tint
    
    if(target != null &&
        isAttacking && 
        random(100)<30) {

      if(playerTeam) {
        stroke(255,255,0);
      } else {
        stroke(0,255,0);
      }
      
      line(meX,meY,
             target.meX+random(-6.99,7),
             target.meY+random(-6.99,7));
    }
    
  }
}
