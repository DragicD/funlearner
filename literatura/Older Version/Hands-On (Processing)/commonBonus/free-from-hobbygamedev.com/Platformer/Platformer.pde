/* Example Code for Platformer
 * By Chris DeLeon
 * 
 * For more free resources about hobby videogame development, check out:
 * http://www.hobbygamedev.com/
 * 
 * Project compiles in Processing - see Processing.org for more information!
 */

// these next 2 lines are used for sound
import ddf.minim.*;
Minim minim;

// for storing and referencing animation frames for the player character
PImage guy_stand, guy_run1, guy_run2;

// music and sound effects
AudioPlayer music; // AudioPlayer uses less memory. Better for music.
AudioSample sndJump, sndCoin; // AudioSample plays more respnosively. Better for sound effects.

// we use this to track how far the camera has scrolled left or right
float cameraOffsetX;

Player thePlayer = new Player();
World theWorld = new World();
Keyboard theKeyboard = new Keyboard();

PFont font;

// we use these for keeping track of how long player has played
int gameStartTimeSec,gameCurrentTimeSec;

// by adding this to the player's y velocity every frame, we get gravity
final float GRAVITY_POWER = 0.5; // try making it higher or lower!

void setup() { // called automatically when the program starts
  size(600,480); // how large the window/screen is for the game
  
  font = loadFont("SansSerif-20.vlw");

  guy_stand = loadImage("guy.png");
  guy_run1 = loadImage("run1.png");
  guy_run2 = loadImage("run2.png");
  
  cameraOffsetX = 0.0;
  
  minim = new Minim(this);
  music = minim.loadFile("Charpentier_-_Super_Flumina_Babylonis.mp3", 1024);
  music.loop();
  int buffersize = 256;
  sndJump = minim.loadSample("jump.wav", buffersize);
  sndCoin = minim.loadSample("coin.wav", buffersize);
  
  frameRate(24); // this means draw() will be called 24 times per second
  
  resetGame(); // sets up player, game level, and timer
}

void resetGame() {
  // This function copies start_Grid into worldGrid, putting coins back
  // multiple levels could be supported by copying in a different start grid
  
  thePlayer.reset(); // reset the coins collected number, etc.
  
  theWorld.reload(); // reset world map

  // reset timer in corner
  gameCurrentTimeSec = gameStartTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
}

Boolean gameWon() { // checks whether all coins in the level have been collected
  return (thePlayer.coinsCollected == theWorld.coinsInStage);
}

void outlinedText(String sayThis, float atX, float atY) {
  textFont(font); // use the font we loaded
  fill(0); // white for the upcoming text, drawn in each direction to make outline
  text(sayThis, atX-1,atY);
  text(sayThis, atX+1,atY);
  text(sayThis, atX,atY-1);
  text(sayThis, atX,atY+1);
  fill(255); // white for this next text, in the middle
  text(sayThis, atX,atY);
}

void updateCameraPosition() {
  int rightEdge = World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE-width;
  // the left side of the camera view should never go right of the above number
  // think of it as "total width of the game world" (World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE)
  // minus "width of the screen/window" (width)
  
  cameraOffsetX = thePlayer.position.x-width/2;
  if(cameraOffsetX < 0) {
    cameraOffsetX = 0;
  }
  
  if(cameraOffsetX > rightEdge) {
    cameraOffsetX = rightEdge;
  }
}

void draw() { // called automatically, 24 times per second because of setup()'s call to frameRate(24)
  pushMatrix(); // lets us easily undo the upcoming translate call
  translate(-cameraOffsetX,0.0); // affects all upcoming graphics calls, until popMatrix

  updateCameraPosition();

  theWorld.render();
    
  thePlayer.inputCheck();
  thePlayer.move();
  thePlayer.draw();
  
  popMatrix(); // undoes the translate function from earlier in draw()
  
  if(focused == false) { // does the window currently not have keyboard focus?
    textAlign(CENTER);
    outlinedText("Click this area to play.\n\nUse arrows to move.\nSpacebar to jump.",width/2, height-90);
  } else {
    textAlign(LEFT); 
    outlinedText("Coins:"+thePlayer.coinsCollected +"/"+theWorld.coinsInStage,8, height-10);
    
    textAlign(RIGHT);
    if(gameWon() == false) { // stop updating timer after player finishes
      gameCurrentTimeSec = millis()/1000; // dividing by 1000 to turn milliseconds into seconds
    }
    int minutes = (gameCurrentTimeSec-gameStartTimeSec)/60;
    int seconds = (gameCurrentTimeSec-gameStartTimeSec)%60;
    if(seconds < 10) { // pad the "0" into the tens position
      outlinedText(minutes +":0"+seconds,width-8, height-10);
    } else {
      outlinedText(minutes +":"+seconds,width-8, height-10);
    }
    
    textAlign(CENTER); // center align the text
    outlinedText("Music by Charpentier, Code by Chris DeLeon",width/2, 25);
    if(gameWon()) {
      outlinedText("All Coins Collected!\nPress R to Reset.",width/2, height/2-12);
    }
  }
}

void keyPressed() {
  theKeyboard.pressKey(key,keyCode);
}

void keyReleased() {
  theKeyboard.releaseKey(key,keyCode);
}

void stop() { // automatically called when program exits. here we'll stop and unload sounds.
  music.close();
  sndJump.close();
  sndCoin.close();
 
  minim.stop();

  super.stop(); // tells program to continue doing its normal ending activity
}
