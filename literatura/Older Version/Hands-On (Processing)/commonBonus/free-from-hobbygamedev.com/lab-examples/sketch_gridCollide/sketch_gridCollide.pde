int playerX=100,playerY=100;
PImage ourHero;

void setup() {
  size(600, 400);
  updateCoinCount(); 
  ourHero = loadImage("character.png");
}

void draw() {
  handleKeyStates();
  
  background(100);
  worldDrawGrid();
  
  fill(255,255,255);
  image(ourHero,playerX-ourHero.width/2,
                playerY-ourHero.height/2);
  //ellipse(playerX,playerY,10,10);
  
  if(coinsInWorld == 0) {
    text("YOU WIN!!!",
       width-100,height-30);
  } else {
    text(coinsInWorld+" / "+totalCoinsInWorld,
       width-100,height-30);
  }
}
