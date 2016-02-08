// position
final int EVIL_Y = 61;

// animation frame count
final int EVIL_ANIM_FRAMES = 2;

// animated images
PImage [] evilImg = new PImage[EVIL_ANIM_FRAMES];

// positions and speed during play
float evilX;
float evilSpeedX;

// functions
void loadEvilImg() {
  for(int i=0;i<EVIL_ANIM_FRAMES;i++) {
    evilImg[i] = loadImage("evilDropper"+i+".png");
  }
  
  evilX = width/6; // set a start position
}

void evilLevelTuning(int thisLevel) {
  evilSpeedX = EVIL_SPEED_X_BASE+thisLevel*EVIL_CHANGE_PER_LEVEL_SPEED;
}

void drawEvil() {
  int evilPoseFrame;
  
  if(playerLives == 0) {
    evilPoseFrame = 1;
  } else if (waitingForClickToBegin && 
                (score==0 || deathSequence)) {
    evilPoseFrame = 1;
  } else {
    evilPoseFrame = 0;
  }
  
  image(evilImg[evilPoseFrame],
              evilX-evilImg[0].width/2,EVIL_Y-evilImg[0].height/2);
}

void moveEvil() {
  if(bombsThrownThisRound == bombsPerThisRound()) {
    return; // waits after dropping the last bomb for the round
  }
  
  if(dropStun > 0) { // still in pause from most recent bomb drop
    dropStun--;
    return;
  }
  
  if(waitingForClickToBegin) { // shouldn't move until the game starts
    return;
  }
  
  evilX += evilSpeedX;
  
  // bounce the enemy off the edges to keep him in motion
  if(evilX>width-evilImg[0].width && evilSpeedX>0) {
    evilSpeedX = -evilSpeedX;
  }
  if(evilX<evilImg[0].width && evilSpeedX<0) {
    evilSpeedX = -evilSpeedX;
  }
  
  // periodically but unpredictably reverse direction
  if(AIReverseDelay--<0) {
    AIReverseDelay = (int)(random(EVIL_CHANGEDIR_FREQ_MIN,EVIL_CHANGEDIR_FREQ_MAX));
    evilSpeedX = -evilSpeedX;
  }
  
  handleBombDropping(); // defined in the Bomb file/tab
}
