// position
final int PLAYER_Y = 367;

// default lives at start
final int START_LIVES = 3;

// animation frame count
final int CATCHER_ANIM_FRAMES = 4;

// animated images
PImage [] playerImg = new PImage[CATCHER_ANIM_FRAMES]; // images
int [] paddleAnimFrame = new int[START_LIVES]; // separate paddles

// how many paddles the player currently has
int playerLives = START_LIVES;

// functions
void loadPlayerImg() {
  for(int i=0;i<CATCHER_ANIM_FRAMES;i++) {
    playerImg[i] = loadImage("catcher"+i+".png");
  }
  for(int i=0;i<START_LIVES;i++) { // set each paddle's frame to 0
    paddleAnimFrame[i] = 0;
  }
}

void playerDrawPaddles() {
  for(int i=0;i<playerLives;i++) {
    if(paddleAnimFrame[i] > 0 && random(10)<2.0) {
      paddleAnimFrame[i]--;
    }
    image(playerImg[ paddleAnimFrame[i] ],mouseX-playerImg[0].width/2,PLAYER_Y+i*PADDLE_SPACING-playerImg[0].height/2);
  }
}
