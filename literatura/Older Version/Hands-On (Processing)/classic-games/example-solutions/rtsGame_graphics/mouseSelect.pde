final float SELECTOR_RANGE = 12.5;

int lassoX1,lassoY1,lassoX2,lassoY2;

void resetMouseLasso() {
  lassoX1=lassoY1=lassoX2=lassoY2=0;
}

void drawMouse() {
  noFill();
  stroke(0);
  ellipse(mouseX,mouseY,
           SELECTOR_RANGE*2.0,SELECTOR_RANGE*2.0);
           
  if(lassoX1 != 0 && lassoY1 != 0) {
    lassoX2 = mouseX;
    lassoY2 = mouseY;
    noFill();
    rect(lassoX1,lassoY1,lassoX2-lassoX1,lassoY2-lassoY1);
  }
}

void mousePressed() { // called when mouse button goes down
  if(mouseButton == RIGHT) {
    selectedUnits.clear();
    return;
  }
  
  newSelection = null;
  for(int i=0;i<units.size();i++) {
    Unit eachUnit = (Unit)units.get(i);
    eachUnit.mouseCheck();
  }
  if(newSelection != null) {
    if(newSelection.playerTeam) {
      selectedUnits.clear();
      selectedUnits.add(newSelection);
    } else if(selectedUnits.size() > 0) {
      for(int i=0;i<selectedUnits.size();i++) {
        Unit eachUnit = (Unit)selectedUnits.get(i);
        eachUnit.target = newSelection;
      }
    } else { // lets us lasso select drag from over enemy units
      lassoX1=mouseX;
      lassoY1=mouseY;
    }
  } else { // start lasso select if no unit clicked on
    lassoX1=mouseX;
    lassoY1=mouseY;
  }
}

void mouseReleased() { // called when mouse button goes up
  if(lassoX1==0 && lassoY1==0) {
    return;
  }
  // this next line distinguishes a click (release near press)
  // from a drag, to know whether to lasso select or move selection
  else if( dist(lassoX1,lassoY1,mouseX,mouseY) < 8.0 ) {
    if(selectedUnits.size() > 0) {
      int formationDimension = (int)sqrt(selectedUnits.size()+2);
      for(int i=0;i<selectedUnits.size();i++) {
        Unit eachUnit = (Unit)selectedUnits.get(i);
        eachUnit.gotoMouse(i,formationDimension);
      }
    }
  } else {
    // lasso selection is done by comparing rectangle edges to each
    // unit's coordinates. this kind of comparison is easier if we
    // can count on which horizontal variable is left of the other,
    // and which vertical variable is above the other. These next
    // couple of comparisons switch the variables so we when doing
    // the comparison we can count on lassoX1 being left of lassoX2
    // and lassoY1 being above lassoY2
    int tempSwap;
    if(lassoX2 < lassoX1) {
      tempSwap = lassoX2;
      lassoX2 = lassoX1;
      lassoX1 = tempSwap;
    }
    if(lassoY2 < lassoY1) {
      tempSwap = lassoY2;
      lassoY2 = lassoY1;
      lassoY1 = tempSwap;
    }
    
    // forget any selected units...
    selectedUnits.clear();
    // ...then accumulate as selected any units in the lasso
    for(int i=0;i<units.size();i++) {
      Unit eachUnit = (Unit)units.get(i);
      if(eachUnit.playerTeam && eachUnit.isInLasso()) {
        selectedUnits.add(eachUnit);
      }
    }
  }
  
  // lose the lasso information
  resetMouseLasso();
}
