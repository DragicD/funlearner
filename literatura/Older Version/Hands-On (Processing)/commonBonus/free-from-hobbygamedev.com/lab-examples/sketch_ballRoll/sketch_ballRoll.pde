float goalX,goalY,goalDiameter = 40;
final float SLOW_ENOUGH_TO_HIT = 1.0;
int ballStrokes;

void resetAll() {
  ballStrokes = 0;
  resetBall();
}

void setup() {
  size(640,480);
  goalX = width-100;
  goalY = height-100;
  resetAll();
}

void hitBallUseTrig() {
  float angToMouse = atan2(mouseY-ballY,
                           mouseX-ballX);
  float ballSpeed = 5.0;
  ballXV = cos(angToMouse)*ballSpeed;
  ballYV = sin(angToMouse)*ballSpeed;
}

void hitBallUseVectors() {
  float distToMouse = dist(mouseX,mouseY,
                           ballX,ballY);
  float normalizedX = (mouseX-ballX)/distToMouse;                         
  float normalizedY = (mouseY-ballY)/distToMouse;                         
  float ballSpeed = 5.0;
  ballXV = normalizedX*ballSpeed;
  ballYV = normalizedY*ballSpeed;
}

boolean slowEnoughToHit() {
  return (dist(0,0,ballXV,ballYV) < SLOW_ENOUGH_TO_HIT);
}

void mousePressed() {
  if( slowEnoughToHit() ) {
    ballStrokes++;
    
    hitBallUseTrig();
    //hitBallUseVectors();
  }
}

void drawGoal() {
  fill(127,127,127);
  ellipse(goalX,goalY,goalDiameter,goalDiameter);
}

void draw() {
  background(0);
  drawGoal();
  drawAndMoveBall();
  if(slowEnoughToHit()) {
    text("Ready to hit",15,15);
  }
  text("Strokes:"+ballStrokes,width-85,15);
}
