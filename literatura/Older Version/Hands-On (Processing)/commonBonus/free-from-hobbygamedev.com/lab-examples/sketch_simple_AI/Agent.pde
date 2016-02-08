class Agent {
  float posX, posY; // position x (horizontal) and y (vertical)
  float angle, speed; // angle and speed of current movement
  
  int millis_NextNeedForFood; // how many millis since the program started it'll starve
  
  int millis_NextRethink; // how many millins since the program started it'll change AI
  int myMood; // what AI mode is it in?
  // saving these as final int so we can switch-case on them below
  final int MOOD_STANDING = 0; // sit still
  final int MOOD_WANDERING = 1; // run in a straight line in whatever direction last faced
  final int MOOD_DANCING = 2; // run in a tight circle
  final int MOOD_SEEK_BUDDY = 3; // find the nearest other agent, go toward them
  final int MOOD_RUN_FROM_USER = 4; // run from the user's mouse
  final int MOOD_FIND_FOOD = 5; // find food in acceptable range, run toward it
  Agent myBuddy = null; // if there's a buddy being chased, this is a reference to it
  
  // we'll use these to color the Agent different based on its AI mode. These are RGB sets
  int[][] moodColor = {  { 255,   0,   0}, // standing
                         { 255, 255,   0}, // wandering
                         {   0, 255, 255}, // dancing
                         { 255,   0, 255}, // seek buddy
                         { 255, 255, 255}, // run from user
                         { 127, 255, 127}  // find food
                         };
  
  Agent() { // constructor, code to initialize this agent when created
    posX = mouseX; // default to create each new agent where the user's mouse is located
    posY = mouseY;
    angle = random(0.0, TWO_PI); // set the angle to a random value in radians
    // speed = 1.0; // AI modes constantly set speed, this doesn't really matter
    millis_NextRethink = millis() + 100; // rethink AI mode 100 milliseconds after now
    myMood = MOOD_STANDING; // default to standing still for a moment
    millis_NextNeedForFood = millis() + 2000; // need food within 2 seconds of now
  }
  
  void AI() { // helper method called in drawAndMove(), all of the agent's AI code
    if( millis_NextNeedForFood - millis() < 750) { // 0.75 sec left until starvation?
      myMood = MOOD_FIND_FOOD; // then find food!
      millis_NextRethink = millis() + 750; // for 0.75 sec (finding food will reset this)
    } else if( dist(mouseX,mouseY, posX,posY) < 40.0 ) { // within 40 pixels of mouse?
      myMood = MOOD_RUN_FROM_USER; // run from it!
      millis_NextRethink = millis() + 600; // for 0.6 sec
    }
    
    if(millis_NextRethink < millis()) { // time to change AI behaviors?
      millis_NextRethink = millis() + (int)random(350,900); // keep it for 0.35 to 0.9 sec
      
      float baseBehaviorOn = random(0,10); // roll a "10 sided die" for easy probabilities
      if(baseBehaviorOn < 3.0) { // 30% chance of standing still for this "round"
        myMood = MOOD_STANDING;
      } else if(baseBehaviorOn < 8.0) { // (80-30), so 50% chance of aimless wandering
        myMood = MOOD_WANDERING;
      } /*else if(baseBehaviorOn < 8.0) { // dancing will only happen from social meeting
        myMood = MOOD_DANCING;
      } */ else { // otherwise find a nearby buddy to move toward
        myMood = MOOD_SEEK_BUDDY;
        
        myBuddy = null; // reset knowledge of any previously found buddy
        float distToNearestBuddy = 10000.0; // closest value found, start larger than screen
        for(int i=0; i<agents.size(); i++) { // for each agent
          Agent oneAgent = (Agent)agents.get(i); // get a reference to that agent
          if( oneAgent != this // if that agent isn't the one we're in the code for
              &&  // and also, if the distance to that agent is closer than any we found
              dist(oneAgent.posX,oneAgent.posY, posX, posY) < distToNearestBuddy ) {
            // then update the nearest distance found
            distToNearestBuddy = dist(oneAgent.posX,oneAgent.posY, posX, posY);
            // and set that agent to be the closest one we've found so far
            myBuddy = oneAgent;
          } // end of if (dist closer)
        } // end of for agents.size()
        
      } // end of else
    } // end of millis() updating AI mood
    
    switch(myMood) { // run different code based on which state the AI is in
      case MOOD_STANDING:
        speed = 0.0; // don't move
        break;
      case MOOD_WANDERING:
        speed = 1.2; // move modestly quickly in whatever direction was last faced
        break;
      case MOOD_DANCING:
        speed = 2.6; // move rapidly
        angle += 1.0; // but in a very tight/small circle
        break;
      case MOOD_SEEK_BUDDY:
        if(myBuddy != null) { // if we found a buddy
          angle = atan2(myBuddy.posY-posY, myBuddy.posX-posX); // get the angle to it
          speed = 0.9; // walk toward it
          
          // if we get within 5 pixels of our buddy
          if( dist(myBuddy.posX,myBuddy.posY, posX,posY) < 5.0) {
            // then make us both stop what we're doing to dance here for 3 seconds
            myBuddy.myMood = MOOD_DANCING;
            myMood = MOOD_DANCING;
            myBuddy.millis_NextRethink = millis() + 3000;
            millis_NextRethink = millis() + 3000;
          }
        } else { // no buddy found? stand until AI timer updates to a new behavior
          myMood = MOOD_STANDING;
        }
        break;
      case MOOD_RUN_FROM_USER:
        angle = atan2(mouseY-posY, mouseX-posX) + PI; // 180 degress from angle to mouse
        speed = 2.0; // run! we're scared!
        break;
      case MOOD_FIND_FOOD:
        for(int i=0; i<foods.size(); i++) { // go through each food
          Food oneFood = (Food)foods.get(i); // get a reference to that food
          // if it's within 200 pixels of us
          if(dist(oneFood.posX,oneFood.posY, posX, posY) < 200.0) {
            angle = atan2(oneFood.posY-posY, oneFood.posX-posX); // get angle to it
            speed = 3.0; // run! we're hungry!
            break;
          }
        }
        break;
    }
  }
  
  boolean tooHungry() { // has too much time passed without food?
    return (millis_NextNeedForFood < millis());
  }
  
  void eatStuffCheck() { // are we close enough to any food to eat it?
    // iterate backwards through the list, since we may remove from it within the loop
    for(int i=foods.size()-1; i>=0; i--) { // go through each food
      Food oneFood = (Food)foods.get(i); // get a reference to it
      if(dist(oneFood.posX,oneFood.posY, posX, posY) < 10.0) { // within 10 pixels of it?
        foods.remove(i); // remove it
        
        millis_NextNeedForFood = millis() + 4000; // bump starvation time to 4 sec from now
        
        myMood = MOOD_STANDING; // make us sit in place briefly to look like we're eating
        millis_NextRethink = millis() + 500; // reconsider behavior after half a second
      } // end of if within 10 pixels
    } // end of for each food
    
  } // end of eatStuffCheck
  
  void drawAndMove() { // called on every agent every frame; run logic and draw on screen
    posX += speed * cos(angle); // move horizontally by x component of  angle times speed
    posY += speed * sin(angle); // move vertically by x component of  angle times speed
    
    AI(); // do the AI behavior logic
    boundsCheck(); // keep us on the screen
    eatStuffCheck(); // eat any food that we're near enough to
    
    noStroke(); // turn off outline
    // color based on mood
    fill( moodColor[myMood][0], moodColor[myMood][1], moodColor[myMood][2] );
    ellipse(posX,posY,10,10); // draw a 10x10 circle at its position
    stroke(255,255,0); // turn on line drawing, color yellow (full R, full G, no B)
    line(posX,posY, // draw a line from its center...
         posX + cos(angle)*10.0, posY + sin(angle)*10.0); // to 10 pixels in the way it's facing
  }
  
  void boundsCheck() { // helper method to keep our agent on the screen
    if(posX < 0) { // if we're off the left side of the screen
      posX = 0; // put us back on the left edge
    }
    if(posX >= width) { // if we're off the right side of the screen
      posX = width-1; // put us back on the right edge
    }
    if(posY < 0) { // if we're off the top of the screen
      posY = 0; // put us back on the top edge
    }
    if(posY >= height) { // if we're off the btotom of the screen
      posY = height-1; // put us back on the bottom edge
    }
  }
}
