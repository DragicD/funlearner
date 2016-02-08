class ArmedSpaceCraft extends WrappingPosition {
  protected ArrayList myShots;

  ArmedSpaceCraft() {
    myShots = new ArrayList();
    reset();
  }

  protected void reset() {
    myShots.clear();
  }

  protected void updateShots() {
    // we go through this for loop backwards since we're removing entries while iterating
    // if we removed an entenemyListry while iterating forward, we'd skip an entry (!)
    for (int i=myShots.size()-1; i>=0; i--) { // for each shot...
      LaserShot oneShot = (LaserShot)myShots.get(i); // get the shot at that index
      if (oneShot.readyToRemove()) {
        myShots.remove(i);
      } 
      else {
        oneShot.updatePosition(); // handle logic for that shot
      }
    }
  }

  void drawShots() {
    for (int i=0; i<myShots.size(); i++) { // for each shot...
      LaserShot oneShot = (LaserShot)myShots.get(i); // get the shot at that index
      oneShot.drawShot(); // handle drawing for that shot
    }
  }
}

