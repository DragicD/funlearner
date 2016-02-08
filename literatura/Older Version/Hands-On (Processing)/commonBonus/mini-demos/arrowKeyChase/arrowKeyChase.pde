int posX = 250;
int posY = 200;

int eneX = 50;
int eneY = 50;

void setup() {
  size(800,600);
}

void keyPressed() {
  if(keyCode==LEFT)
  {
    posX = posX - 25;
  }
  if(keyCode==RIGHT)
  {
    posX = posX + 25;
  }
  if(keyCode==UP)
  {
    posY = posY - 25;
  }
  if(keyCode==DOWN)
  {
    posY = posY + 25;
  }

  if(posX < 0)
  {
    posX = 0;
  }
  if(posX > 780)
  {
    posX = 780;
  }  
  if(posY < 0)
  {
    posY = 0;
  }
  if(posY > 580)
  {
    posY = 580;
  }
}

void moveEnemy() {
  if(eneX < posX) {
    eneX = eneX + 1;
  }
  if(eneX > posX) {
    eneX = eneX - 1;
  }
  if(eneY < posY) {
    eneY = eneY + 1;
  }
  if(eneY > posY) {
    eneY = eneY - 1;
  }
}

void draw() {
  moveEnemy();
  
  background(0);
  
  fill(0,255,0);  
  rect(posX,posY,20,20);

  fill(255,0,0);  
  ellipse(eneX,eneY,20,20);  
}
