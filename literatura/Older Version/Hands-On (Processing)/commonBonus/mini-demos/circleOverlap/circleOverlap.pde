int xpos=300;
int ypos=300;
int bigsize=54;
int lilsize= 87;
float distance ()
{
  float xd=mouseX-xpos;
  float yd=mouseY-ypos;
  return sqrt(xd*xd+yd*yd);
}
void draw () 
{
  if(mousePressed)
  {
    xpos=mouseX;
    ypos=mouseY;
  }
  if (distance()<(bigsize+lilsize)/2)
  {
    background (127, 127, 127);
  }
  else
  {
    background (0, 0, 0);
  }
  ellipse(xpos, ypos, bigsize, bigsize);
  ellipse(mouseX, mouseY, lilsize, lilsize);
}

void setup()
{
  size(800, 600);
}
