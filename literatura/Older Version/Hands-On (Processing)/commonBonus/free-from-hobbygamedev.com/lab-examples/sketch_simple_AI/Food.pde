class Food { // name of class
  float posX, posY; // position of Food
  
  Food() { // Constructor, called when new Food is created
    posX = random(0,width); // give it a random position on the screen
    posY = random(0,height);
  }
  
  void drawAndMove() { // no movement code to execute, so just draw it to the screen
    noStroke(); // no outline
    fill(0,255,0); // fill it with green
    ellipse(posX,posY,6,6); // draw a 6x6 pixel circle at its position
  }
}
