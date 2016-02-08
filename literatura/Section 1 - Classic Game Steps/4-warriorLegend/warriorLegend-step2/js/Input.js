// keyboard keycode constants, determined by printing out evt.keyCode from a key handler  
const KEY_LEFT_ARROW = 37;
const KEY_UP_ARROW = 38;
const KEY_RIGHT_ARROW = 39;
const KEY_DOWN_ARROW = 40;
const KEY_LETTER_W = 87;
const KEY_LETTER_A = 65;
const KEY_LETTER_S = 83;
const KEY_LETTER_D = 68;

function initInput() {
  document.addEventListener("keydown", keyPressed);
  document.addEventListener("keyup", keyReleased);
  
  p1.setupControls(KEY_UP_ARROW,KEY_DOWN_ARROW,KEY_LEFT_ARROW,KEY_RIGHT_ARROW);
  //// removed p2 setupControls
}

function setKeyHoldState(thisKey, thisCar, setTo) {
  if(thisKey == thisCar.controlKeyForTurnLeft) {
    thisCar.keyHeld_TurnLeft = setTo;
  }
  if(thisKey == thisCar.controlKeyForTurnRight) {
    thisCar.keyHeld_TurnRight = setTo;
  }
  if(thisKey == thisCar.controlKeyForGas) {
    thisCar.keyHeld_Gas = setTo;
  }
  if(thisKey == thisCar.controlKeyForReverse) {
    thisCar.keyHeld_Reverse = setTo;
  }
}

function keyPressed(evt) {
  setKeyHoldState(evt.keyCode, p1, true);
  //// removed p2 setKeyHoldState
  evt.preventDefault(); // without this, arrow keys scroll the browser!
}

function keyReleased(evt) {
  setKeyHoldState(evt.keyCode, p1, false);
  //// removed p2 setKeyHoldState
}