const KEY_UP_ARROW = 38;
const KEY_DOWN_ARROW = 40;
const KEY_LETTER_W = 87;
const KEY_LETTER_S = 83;

const KEY_TOPNUM_1 = 49; ////
const KEY_TOPNUM_2 = 50; ////
const KEY_KEYPAD_1 = 97; ////
const KEY_KEYPAD_2 = 98; ////

var leftPlayerKeyHeld_Up = false;
var leftPlayerKeyHeld_Down = false;
var rightPlayerKeyHeld_Up = false;
var rightPlayerKeyHeld_Down = false;

function setKeyHoldState(thisKey, setTo) {
  if(thisKey == KEY_LETTER_W) {
    leftPlayerKeyHeld_Up = setTo;
  }
  if(thisKey == KEY_LETTER_S) {
    leftPlayerKeyHeld_Down = setTo;
  }
  if(thisKey == KEY_UP_ARROW) {
    rightPlayerKeyHeld_Up = setTo;
  }
  if(thisKey == KEY_DOWN_ARROW) {
    rightPlayerKeyHeld_Down = setTo;
  }
}

function keyPressed(evt) {
  setKeyHoldState(evt.keyCode, true);
  
  if(showingMenuScreen) { ////
    if(evt.keyCode == KEY_TOPNUM_1 || evt.keyCode == KEY_KEYPAD_1) { ////
      paddle1Score = 0; ////
      paddle2Score = 0; ////
      twoPlayerMode = false; ////
      showingMenuScreen = false; ////
    } ////
    if(evt.keyCode == KEY_TOPNUM_2 || evt.keyCode == KEY_KEYPAD_2) { ////
      paddle1Score = 0; ////
      paddle2Score = 0; ////
      twoPlayerMode = true; ////
      showingMenuScreen = false; ////
    } ////
  } ////
  
  evt.preventDefault(); // without this, arrow keys scroll the browser!
}

function keyReleased(evt) {
  setKeyHoldState(evt.keyCode, false);
}

function calculateMousePos(evt) {
  var rect = canvas.getBoundingClientRect(), root = document.documentElement;

  // account for the margins, canvas position on page, scroll amount, etc.
  var mouseX = evt.clientX - rect.left - root.scrollLeft;
  var mouseY = evt.clientY - rect.top - root.scrollTop;
  return {
    x: mouseX,
    y: mouseY
  };
}

function handleMousemove(evt) {
  if(twoPlayerMode == false) {
    var mousePos = calculateMousePos(evt);
    paddle1Y = mousePos.y - (PADDLE_HEIGHT/2); // minus half paddle height to center
  }
}

function setupInputEventHandlers() {
  //// removed handleMousedown, now using 1 or 2 keys from title screen to start play
  canvas.addEventListener('mousemove', handleMousemove);
  document.addEventListener("keydown", keyPressed);
  document.addEventListener("keyup", keyReleased);
}