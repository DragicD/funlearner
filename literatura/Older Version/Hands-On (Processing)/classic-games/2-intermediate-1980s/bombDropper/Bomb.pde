// animation frame count
final int BOMB_ANIM_FRAMES = 4;
final int BLAST_ANIM_FRAMES = 2;

// animated images
PImage [] bombImg = new PImage[BOMB_ANIM_FRAMES+BLAST_ANIM_FRAMES];

// functions for all bombs
void loadBombImg() {
  for(int i=0;i<BOMB_ANIM_FRAMES;i++) {
    bombImg[i] = loadImage("fallingBad"+i+".png");
  }
  for(int i=BOMB_ANIM_FRAMES;i<BOMB_ANIM_FRAMES+BLAST_ANIM_FRAMES;i++) {
    bombImg[i] = loadImage("blast"+(i-BOMB_ANIM_FRAMES)+".png");
  }
}

void bombLevelTuning(int thisLevel) {
  bombFall = BOMB_FALLSPEED_BASE+thisLevel*CHANGE_PER_LEVEL_SPEED_BOMB;
  bombFreqAdjustment = thisLevel*CHANGE_PER_LEVEL_FREQ_BOMB;
}

void handleBombDropping() {
  if(bombDelay--<0 && bombsThrownThisRound < bombsPerThisRound()) {
    bombDelay = (int)(random(BOMB_DROPFREQ_MIN,BOMB_DROPFREQ_MAX)-bombFreqAdjustment);
    if(bombDelay < BOMB_DROPFREQ_CAP) {
      bombDelay = BOMB_DROPFREQ_CAP;
    }
    if(roundNum%2==1) {
      // bombs more frequent on odd levels
      bombDelay = int(bombDelay*ODD_LEVEL_BOMB_FREQ_MULT);
    }
    
    sndDropFuse.trigger();
    dropStun = EVIL_DROP_STUN_TIME;
    bombsThrownThisRound++;
    bombSet.add(new Bomb());
  }
}

// class describing each individual bomb instance
class Bomb {
  float x,y;
  boolean flipped;
  int animFrame;
  
  Bomb() {
    x = evilX;
    y = EVIL_Y;
    flipped = (random(10.0)<5.0);
    animFrame = int(random(BOMB_ANIM_FRAMES));
  }
  
  void moveAndDraw() {
    if(waitingForClickToBegin==false) {
      if(random(10.0)<4.0 &&
         ++animFrame>=BOMB_ANIM_FRAMES) {
        animFrame=0;
      }

      y += bombFall;
      collisionDetection();
    }
    
    pushMatrix();
    translate(x,y);
    if(flipped==false) {
      scale(-1,1); // flip horizontally by scaling horizontally by -100%
    }
    image(bombImg[animFrame],0,0);
    popMatrix();
  }
  
  void bombPassedPlayerSoDetonate() {
    waitingForClickToBegin = true;
    deathSequence = true;
    if(roundNum>0) {
      roundHandicap = true;
      roundNum--;
    }
    deathSequenceDelay = DEATH_SEQUENCE_DELAY;
    bombsThrownThisRound = bombsCaughtThisRound;
  }
  
  void bombCaughtSoScoreIt(int byPaddle) {
    score += pointsPerBombThisRound();
    if(score >= MAX_SCORE) {
      score = MAX_SCORE;
    }
    
    // initiate splash animation
    paddleAnimFrame[byPaddle] = CATCHER_ANIM_FRAMES-1;
    
    sndBucketCatch.trigger();
    bombsCaught++;
    bombsCaughtThisRound++;
    if(bombsCaughtThisRound == bombsPerThisRound()) {
      waitingForClickToBegin = true;
      sndDropFuse.stop();
      roundHandicap = false;
      roundNum++;
    }
    bombSet.remove(this);
  }
  
  void collisionDetection() {
    if(y>height-evilImg[0].height/2-bottomImg.height) {
      bombPassedPlayerSoDetonate();
    } else {
      for(int ii=0;ii<playerLives;ii++) { // for each player paddle...
        // is this bomb vertically aligned with that paddle?
        if(abs(y-(PLAYER_Y+((float)(ii)-0.5)*PADDLE_SPACING))<playerImg[0].height/2+bombImg[0].height/2) {
          // if so, is the bomb overlapping the paddle horizontally, too?
          if(abs(x-mouseX)<playerImg[0].width/2+bombImg[0].width/2) {
            bombCaughtSoScoreIt(ii);
            break; // prevent it from registering on multiple paddles
          }
        }
      }
    }
  } // end of void collisionDetection
} // end of class Bomb
