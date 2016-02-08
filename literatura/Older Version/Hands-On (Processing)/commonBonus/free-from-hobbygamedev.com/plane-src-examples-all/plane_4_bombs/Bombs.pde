
class Bomb {
  PVector pos,v; // position and velocity of the bomb
  Boolean isAlive; // used to mark a bomb for deletion after it goes out of bounds or explodes

  // Constructor. This is called when a new bomb is created
  Bomb() {
    isAlive = true; // once set to false, the bomb will be removed from the bomb list
    pos = new PVector(mouseX,mouseY); // start the bomb from the current mouse position
    v = new PVector(2,9); // moving down and to the right
  }
  
  void handle() {
    int h=0,bx=int(pos.x);
    
    if(bx<0 || bx>=land.width) { // out of bounds?
      isAlive = false; // erase it
      return;
    }   
    
    h = heightAt(bx);
    
    // v.x *= 0.95; // wind resistance
    v.y += 0.6; // gravity
    
    pos.add(v);
    
    if(pos.x < 0 || pos.x >= land.width || // off left or right side of world?
       pos.y < 0) { // off the top of the world?
      isAlive = false;
    } else if(pos.y >= land.height-1 || // off bottom of the world? or...
              (pos.y>h)) { // underground?
      pos.y=h; // move bomb up to ground level for explosion
      
      isAlive = false; // mark it for deletion
      shredHole(pos.x,pos.y,90,6000);
    } else {
      pushMatrix();
      translate(pos.x,pos.y);
      float mang;
      mang = atan2(v.y,v.x);
      rotate(mang);
      image(bombImg,0,0);
      popMatrix();      
    }
  }
  
  Boolean finished() {
    return (isAlive==false);
  }
}
