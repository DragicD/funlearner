/* Hands-On Game Programming
 * By Chris DeLeon
 *
 * Commercial educational example. Do not distribute source.
 *
 * Feel free to use this code as a starting point or as scrap
 * parts to harvest from. Your compiled program using the
 * derivative code can be distributed, for free or commercially,
 * without any attribution or mention of Chris DeLeon.
 * (unless used for school - then make clear which work is yours!)
 */

Player p1, p2; 

void setup() {
  size(800,600);
  p1 = new Player("player1.png");
  p2 = new Player("player2.png");
  
  loadMapLayout();
  resetGame();
}

void draw() {
  worldDrawGrid();
  
  p1.considerKeyboardInput(keyHeld_Gas_P1,keyHeld_Reverse_P1,
                    keyHeld_TurnLeft_P1,keyHeld_TurnRight_P1);
  p2.considerKeyboardInput(keyHeld_Gas_P2,keyHeld_Reverse_P2,
                    keyHeld_TurnLeft_P2,keyHeld_TurnRight_P2);
  
  p1.updatePosition();
  p1.drawCar();
  
  p2.updatePosition();
  p2.drawCar();
}

void resetGame()
{
  p1.reset();
  p2.reset();
}
