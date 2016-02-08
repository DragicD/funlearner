// I made this out of the example code included here (project directory in source package):
// commonBonus/free-from-hobbygamedev/lab-examples/sketch_gridCollide_better

PImage mainCharacter;

float cameraOffsetX;
float cameraOffsetY;

Player thePlayer = new Player();
World theWorld = new World();
Keyboard theKeyboard = new Keyboard();

void setup() {
  size(600,440);
  mainCharacter = loadImage("warrior.png");
  theWorld.loadWorldTileArt();
  resetProgram();
  textSize(20);
}

void resetProgram() {
  thePlayer.reset();  
  theWorld.reload();
}

void updateCameraPosition() {
  int rightEdge = World.GRID_UNITS_WIDE*World.GRID_UNIT_SIZE-width;
  
  cameraOffsetX = thePlayer.position.x-width/2;
  if(cameraOffsetX < 0) {
    cameraOffsetX = 0;
  }
  
  if(cameraOffsetX > rightEdge) {
    cameraOffsetX = rightEdge;
  }

  int bottomEdge = World.GRID_UNITS_TALL*World.GRID_UNIT_SIZE-height;
  
  cameraOffsetY = thePlayer.position.y-height/2;
  if(cameraOffsetY < 0) {
    cameraOffsetY = 0;
  }
  
  if(cameraOffsetY > bottomEdge) {
    cameraOffsetY = bottomEdge;
  }
}

void draw() { // called automatically each frame
  pushMatrix(); // lets us easily undo the upcoming translate call
  translate(-cameraOffsetX,-cameraOffsetY); // affects all upcoming graphics calls, until popMatrix

  updateCameraPosition();

  theWorld.render();
    
  thePlayer.move();
  thePlayer.draw();
  
  popMatrix(); // undoes the translate function from earlier in draw()
  
  // do interface text after popMatrix, so it doesn't scroll with the world
  textAlign(LEFT);
  outlinedText("Keys: "+thePlayer.keysCollected,10,20);
  outlinedText("Stuck? Press R to reset",10,height-8);
  
  if(focused == false) { // does the window currently not have keyboard focus?
    textAlign(CENTER);
    outlinedText("Click this area to give focus.\n\nUse arrows to move.",width/2, height-50);
  }
}

void keyPressed() {
  theKeyboard.pressKey();
}

void keyReleased() {
  theKeyboard.releaseKey();
}

void outlinedText(String sayThis, float atX, float atY) {
  fill(0); // white for the upcoming text, drawn in each direction to make outline
  text(sayThis, atX-2,atY);
  text(sayThis, atX+2,atY);
  text(sayThis, atX,atY-2);
  text(sayThis, atX,atY+2);
  fill(255); // white for this next text, in the middle
  text(sayThis, atX,atY);
}
