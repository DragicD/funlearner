ArrayList ballSet = new ArrayList();

void resetAllBalls() {
  ballSet.clear();
  for(int i=0;i<40;i++) {
    ballSet.add( new Ball(50+(int)random(350),
                          150+(int)random(250),
                          1+(int)random(5),
                          -4-(int)random(6),
                          10+(int)random(35) ) );
  }
}

void keyPressed() {
  if(key == ' ') {
    resetAllBalls();
  }
}

void setup() {
  size(640,440);
  resetAllBalls();
}

void draw() {
  background(0);
  for(int i=0; i<ballSet.size(); i++) {
    Ball oneBall = (Ball)ballSet.get(i);
    oneBall.drawAndMoveBall();
  }
  fill(255,255,255);
  text("Press spacebar to reset",5,15);
}
