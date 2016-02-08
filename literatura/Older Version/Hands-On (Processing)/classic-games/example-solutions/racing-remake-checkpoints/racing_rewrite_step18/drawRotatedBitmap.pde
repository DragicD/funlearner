void drawBitmapCenteredAtLocationWithRotation(PImage graphic,
                        float atX, float atY,float withAngle) {
  pushMatrix();
  translate(atX, atY);
  rotate(withAngle);
  image(graphic,-graphic.width/2,-graphic.height/2);   
  popMatrix();
}
