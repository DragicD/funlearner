/* Hands-On Game Programming
 * By Chris DeLeon
 *
 * Commercial educational example. Do not distribute source.
 *
 * Feel free to use this code as a starting point or as scrap
 * parts to harvest from. Your compiled program using the
 * derivative code can be distributed, for free or commercially,
 * without any attribution or mention of Chris DeLeon.
 * (unless used for school - then make clear which work is yours!)
 */

// Gameplay design inspired by a classic home console game

import ddf.minim.*; // using Minim to play sound effects
Minim minim;

// general globals are defined in the GlobalVals and Tuning tabs/files

void setup() { // setup() happens once at program start
  size(650,500);
  
  scoreFont = loadFont("ArcadeInterlaced-24.vlw");
  textFont(scoreFont, 24);
  textAlign(CENTER, TOP);

  bottomImg = loadImage("bottomGraphic.png");
  backgroundImg = loadImage("background.png");
  
  loadBombImg(); // defined in Bomb tab/file  
  
  loadEvilImg();
  
  loadPlayerImg();

  int buffersize = 256;
  minim = new Minim(this);
  sndBombBurst = minim.loadSample("bomb-burst.mp3", buffersize);
  sndBucketCatch = minim.loadSample("bucket-catch.mp3", buffersize);
  sndBucketLoss = minim.loadSample("bucket-loss.mp3", buffersize);
  sndDropFuse = minim.loadSample("drop-fuse.mp3", buffersize);
  sndExtraLife = minim.loadSample("extralife.mp3", buffersize);
}

void draw() { // draw() happens every frame (automatically)
  int lowest_bomb_i=-1;
  float lowest_bomb_y=-1;
  image(backgroundImg,0,0);
  
  image(bottomImg,0,height-bottomImg.height);
  
  if(score >= scoreGivenLivesFor + EXTRA_LIVES_POINTS) {
    scoreGivenLivesFor = score;
    sndExtraLife.trigger();
    if(playerLives < START_LIVES) {
      playerLives++;
    }
  }
  
  fill(216,213,44);
  text(score,width/2,2);
  
  if(waitingForClickToBegin && deathSequence == false) {
    text("Click to Advance",width/2,height/2);
  }
  
  drawEvil();
  
  // reverse order loop, since moveAndDraw can remove elements of
  // the arraylist, and this way we won't skip a number on the next
  // get(i) access (otherwise for example we remove entry 4, meaning
  // a new entry becomes entry 4 - which was previously 5 - so when
  // we next check entry 5 we'd then have skipped updating 1 bomb)
  for(int i=bombSet.size()-1;i>=0;i--) {
    Bomb eachBomb = (Bomb)bombSet.get(i);
    eachBomb.moveAndDraw();
    if(lowest_bomb_y < eachBomb.y) {
      lowest_bomb_i = i;
      lowest_bomb_y = eachBomb.y;
    }
  }
  
  moveEvil();
  
  if(deathSequence) {
    if(lowest_bomb_i==-1) {
      if(bombSet.size()<1) {
        sndBucketLoss.trigger();
        playerLives--;
        deathSequence = false; // ready to reset
        deathSequenceDelay = 0;
      } else if(--deathSequenceDelay<0) {
        bombSet.remove(0);
        deathSequenceDelay = 15;
      }
    } else if(deathSequenceDelay>0) {
      deathSequenceDelay--;
    } else {
      sndDropFuse.stop();
      deathSequenceDelay = DEATH_SEQUENCE_DELAY;
      Bomb lowestBomb = (Bomb)bombSet.get(lowest_bomb_i);
      if(lowestBomb.animFrame >= BOMB_ANIM_FRAMES+BLAST_ANIM_FRAMES-1) {
        if(bombSet.size()>0) {
          sndBombBurst.trigger();
          bombSet.remove(lowest_bomb_i);
        }
      } else { // animate explosion
        lowestBomb.animFrame++;
      } // end of explosion animation advance
    } // end of else to remove lowest bomb
  } // end of if deathSequence 
  
  playerDrawPaddles();
  
  if(deathSequence && bombSet.size()<1) {
    // cause the screen to flash
    if(deathSequenceDelay%5<3) {
      filter(INVERT);
    } else {
      filter(GRAY);
    }
  }
}

// clear values that need to be zero at round start
void resetLevel() {
  bombDelay = 0;
  bombSet.clear();
  waitingForClickToBegin = false;
  bombsCaughtThisRound = bombsThrownThisRound = 0;

  if(playerLives==0) { // doing a full reset after game over?
    roundHandicap = false;
    score = scoreGivenLivesFor = 0;
    roundNum = 0;
    bombsCaught = 0;
    playerLives = START_LIVES;
  }
}

void mousePressed() {
  if(waitingForClickToBegin && deathSequence==false) {
    resetLevel();
    updateDifficultyTuning();
  }
}


