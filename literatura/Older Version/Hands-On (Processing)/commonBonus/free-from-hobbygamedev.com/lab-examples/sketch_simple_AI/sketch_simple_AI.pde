ArrayList agents = new ArrayList(); // list of AI entities
ArrayList foods = new ArrayList(); // list of food pellets for AI entities to gobble

void setup() { // this function gets called once and only once, when the program starts
  size(640,480); // this sets the window's size for graphics, in pixels
  
  // add some initial food
  for(int i=0; i < 250; i++) {
    foods.add( new Food() );
  }
}

void keyReleased() { // when a keyboard key is released, this function is called
  if(key == 'a' || key == 'A') { // A key, whether or not caps lock is on
    agents.add( new Agent() ); // add Agent. "A" is also for "AIAgent" or "Animal" or "Ant"
  }
  if(key == 'f' || key == 'F') { // F key, whether or not caps lock is on
    for(int i=0; i < 25; i++) { // do the following 25 times:
      foods.add( new Food() ); // add Food. "F" is also for "Fruit"
    }
  }
}

void draw() { // this gets called ~30 times per second
  background(0); // erase what we drew for the previous frame
  
  // uncomment these next two lines to CONSTANTLY add more agents and food (every frame):
  // agents.add( new Agent() );
  // foods.add( new Food() );
  
  for(int i=0; i<foods.size(); i++) { // for each food...
    Food oneFood = (Food)foods.get(i); // get the food at that index
    oneFood.drawAndMove(); // draw that food at its position and run any logic for it
  }
  
  // we go through this for loop backwards since we're removing entries while iterating
  // if we removed an entry while iterating forward, we'd skip an entry (!)
  for(int i=agents.size()-1; i>=0; i--) { // for each agent...
    Agent oneAgent = (Agent)agents.get(i); // get the agent at that index
    if(oneAgent.tooHungry()) { // if the agent has gone too long without food
      agents.remove(i); // remove it from the list of agents
    } else { // otherwise
      oneAgent.drawAndMove(); // draw that agent and run any logic for it
    }
  }
  
  noStroke(); // turn off outline for the rect call that follows
  fill(0,150); // black box with 100 alpha (out of 255; partial transparency)
  rect(2,2,290,62); // draw a box under the instructions text to make it more readable
  
  fill(255); // make the following text white
  // on screen instructions:
  text("First click on canvas to put it in focus",5,15);
  text("Press A key to spawn new AI Agent at mouse",5,30);
  text("Press F key to randomly scatter 25 Food",5,45);
  text("AI Agents dying too quickly? Give them food!",5,60);
}
