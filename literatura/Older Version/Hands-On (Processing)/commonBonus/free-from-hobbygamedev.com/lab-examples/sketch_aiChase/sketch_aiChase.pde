ArrayList allEnemies = new ArrayList();
int deltaMS;
int prevMS;

void setup() {
  size(640, 350);
  
  for(int i=0; i<12; i++) {
    allEnemies.add( new Enemy() );
  }
}

void updateTimer() {
  int msThisFrame = millis(); 
  deltaMS = msThisFrame-prevMS;
  prevMS = msThisFrame;
}

void draw() {
  updateTimer();
  for(int i=0; i<allEnemies.size(); i++) {
    Enemy eachEnemy = (Enemy)allEnemies.get(i);
    eachEnemy.moveAI();
  }

  background(0);
  
  for(int i=0; i<allEnemies.size(); i++) {
    Enemy eachEnemy = (Enemy)allEnemies.get(i);
    eachEnemy.drawAI();
  }
  
  fill(0,255,0);
  rect(mouseX-10,mouseY-10, 20,20);
}
