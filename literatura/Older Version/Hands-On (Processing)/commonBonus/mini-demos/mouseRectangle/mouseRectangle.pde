void setup ()
{
  size(640,480);
}
void draw ()
{
  // RGBA: red green blue alpha, each of 255
  fill(0,0,255,15); // only 15/255 alpha
  // which makes a fade effect, leaving residue
  // between frame updates
  rect(0,0,width,height);
  
  fill(255,255,255); // set color to white for mouse
  // rect arguments are x,y of top left corner
  // then width and height of rectangle
  rect(100,50,mouseX-100,mouseY-50);
}
