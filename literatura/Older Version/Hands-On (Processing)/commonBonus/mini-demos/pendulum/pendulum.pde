float swingPhase = 0.0;
float orbitAng = 0.0;

void setup()
{
  size(400,400);
}

void draw()
{
  swingPhase += 0.035;
  orbitAng += 0.05;
  
  float centerX = width/2;
  float centerY = height/2;
  
  float swingLength = 110;
  float orbitLength = 180;
  
  background(255,255,255);
  
  float swingAng = cos(swingPhase)*PI*0.35+PI*0.5;
  line(centerX,centerY,centerX + cos(swingAng)*swingLength, centerY + sin(swingAng)*swingLength);
  fill(0,255,255);
  ellipse( centerX + cos(swingAng)*swingLength, centerY + sin(swingAng)*swingLength, 30,30 );
  
  fill(255,0,255);
  line(centerX,centerY,centerX + cos(orbitAng)*orbitLength, centerY + sin(orbitAng)*orbitLength);
  ellipse( centerX + cos(orbitAng)*orbitLength, centerY + sin(orbitAng)*orbitLength, 30,30 );
}
