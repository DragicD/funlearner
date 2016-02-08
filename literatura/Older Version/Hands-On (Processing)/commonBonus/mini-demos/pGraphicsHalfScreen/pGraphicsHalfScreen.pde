PImage testImage;
PGraphics halfScreen;

float faceX = 50,faceY = 50;
float faceXV = 5,faceYV = 3;
float faceSpin = 0;

void setup() {
  size(640, 480);
  testImage = loadImage("sampleGraphic.png");
  halfScreen = createGraphics(width,height/2, JAVA2D);
}

void draw() {
  faceMoveAndSpin();
  
  halfScreen.beginDraw();
  halfScreen.pushMatrix();
  halfScreen.translate(faceX,faceY);
  halfScreen.rotate(faceSpin);
  halfScreen.image(testImage,
                        -testImage.width/2, // centering it
                        -testImage.height/2);
  halfScreen.popMatrix();
  halfScreen.endDraw();
  
  image(halfScreen,0,0);
  image(halfScreen,0,height/2);
  
  fill(0,0,0); // setting fill color to black
  rect(0,height/2-1,width,2); // line dividing top and bottom
  
  // no reason we'd want to do this here, I just want to
  // better demonstrate that we can use any position when
  // displaying the separate graphics buffer to the screen
  image(halfScreen,mouseX,mouseY);
}

void faceMoveAndSpin () {
  faceX += faceXV;
  faceY += faceYV;
  
  // millis() with a modulus can be used for simple
  // oscillations, in this case to make it tilt back
  // and forth.
  faceSpin += ((millis()%2000)-1000)*0.0001;
  
  if(faceX < 0 && faceXV < 0.0) {
    faceXV = -faceXV;
  }
  if(faceX > halfScreen.width && faceXV > 0.0) {
    faceXV = -faceXV;
  }
  if(faceY < 0 && faceYV < 0.0) {
    faceYV = -faceYV;
  }
  if(faceY > halfScreen.height && faceYV > 0.0) {
    faceYV = -faceYV;
  }
}
