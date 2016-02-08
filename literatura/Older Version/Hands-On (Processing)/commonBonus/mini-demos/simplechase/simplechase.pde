float trigChaserX;
float trigChaserY;

float comparisonChaserX;
float comparisonChaserY;

void setup()
{
  size(800,600);
  trigChaserX = trigChaserY = 200;
  comparisonChaserX = comparisonChaserY = 500;
}

void chase()
{
  // trigChaser uses trig to find angle toward mouse
  // then uses cos and sin to break into x and y offsets
  // which results in moving straight toward the mouse
  float speed = 1.5;
  float radAngle = atan2(mouseY-trigChaserY,mouseX-trigChaserX);
  
  trigChaserX += cos(radAngle) * speed;
  trigChaserY += sin(radAngle) * speed;
  
  // comparisonChaser just compares each axis
  // which means it can only do 8 way movement: cardinal
  // directions plus 45 degree diagonals
  // this also has the effect that diagonal movement is
  // faster than movement along either axis, since the
  // updates on each axis get added together into hypotenuse
  
  // doesn't move straight at it, but...
  // non trig way to handle chase is simpler:
  if(comparisonChaserX < mouseX)
  {
    comparisonChaserX += speed;
  }
  if(comparisonChaserX > mouseX)
  {
    comparisonChaserX -= speed;
  }

  if(comparisonChaserY < mouseY)
  {
    comparisonChaserY += speed;
  }
  if(comparisonChaserY > mouseY)
  {
    comparisonChaserY -= speed;
  }
}

void draw()
{
  chase();
  
  // using fill and rect instead of background
  // so that we can set low alpha (4th argument) on fill
  // to get a fade/trails effect, better showing paths
  fill(0,0,255,5);
  rect(0,0,width,height);
  
  fill(255,255,255);
  stroke(0,0,0);
  ellipse(mouseX,mouseY,60,60);
  
  fill(0,255,0);
  stroke(0,255,0);
  line(trigChaserX,trigChaserY,mouseX,mouseY);
  ellipse(trigChaserX,trigChaserY,45,45);
  
  fill(255,0,0);
  stroke(255,0,0);
  line(comparisonChaserX,comparisonChaserY,mouseX,mouseY);
  ellipse(comparisonChaserX,comparisonChaserY,45,45);
}
