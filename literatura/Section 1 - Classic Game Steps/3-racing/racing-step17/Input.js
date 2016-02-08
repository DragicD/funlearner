// keyboard keycode constants, determined by printing out evt.keyCode from a key handler  
const KEY_LEFT_ARROW = 37;
const KEY_UP_ARROW = 38;
const KEY_RIGHT_ARROW = 39;
const KEY_DOWN_ARROW = 40;

// keyboard hold state variables, to use keys more like buttons
var keyHeld_Gas = false;
var keyHeld_Reverse = false;
var keyHeld_TurnLeft = false;
var keyHeld_TurnRight = false;

function initInput() { //// moved from Main.js window.onload
  document.addEventListener("keydown", keyPressed);
  document.addEventListener("keyup", keyReleased);
} ////

function setKeyHoldState(thisKey, setTo) {
  if(thisKey == KEY_LEFT_ARROW) {
    keyHeld_TurnLeft = setTo;
  }
  if(thisKey == KEY_RIGHT_ARROW) {
    keyHeld_TurnRight = setTo;
  }
  if(thisKey == KEY_UP_ARROW) {
    keyHeld_Gas = setTo;
  }
  if(thisKey == KEY_DOWN_ARROW) {
    keyHeld_Reverse = setTo;
  }
}

function keyPressed(evt) {
  setKeyHoldState(evt.keyCode, true);
  evt.preventDefault(); // without this, arrow keys scroll the browser!
}

function keyReleased(evt) {
  setKeyHoldState(evt.keyCode, false);
}