int yPos = 200;
int xPos = 250;
void keyPressed()
{ 
  if(keyCode == UP)   {
    yPos = yPos - 50 ;
  }

  if(keyCode == DOWN) {
    yPos = yPos + 50;
  }
  
  if(keyCode == RIGHT) {
     xPos = xPos + 50;
  } 
 
  if(keyCode == LEFT)  {
     xPos = xPos - 50;
  } 
    
  if(key == 'r') {
    yPos = 50;
  }
}

void setup() {
  size(640,480);
}

void draw() {
  background(0);
  rect(xPos,yPos,50,50);
}
