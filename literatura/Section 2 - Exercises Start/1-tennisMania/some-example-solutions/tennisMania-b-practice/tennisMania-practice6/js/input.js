const KEY_UP_ARROW = 38; ////
const KEY_DOWN_ARROW = 40; ////
const KEY_LETTER_W = 87; ////
const KEY_LETTER_S = 83; ////

var leftPlayerKeyHeld_Up = false; ////
var leftPlayerKeyHeld_Down = false; ////
var rightPlayerKeyHeld_Up = false; ////
var rightPlayerKeyHeld_Down = false; ////

function setKeyHoldState(thisKey, setTo) { ////
  if(thisKey == KEY_LETTER_W) { ////
    leftPlayerKeyHeld_Up = setTo; ////
  } ////
  if(thisKey == KEY_LETTER_S) { ////
    leftPlayerKeyHeld_Down = setTo; ////
  } ////
  if(thisKey == KEY_UP_ARROW) { ////
    rightPlayerKeyHeld_Up = setTo; ////
  } ////
  if(thisKey == KEY_DOWN_ARROW) { ////
    rightPlayerKeyHeld_Down = setTo; ////
  } ////
} ////

function keyPressed(evt) { ////
  setKeyHoldState(evt.keyCode, true); ////
  evt.preventDefault(); // without this, arrow keys scroll the browser! ////
} ////

function keyReleased(evt) { ////
  setKeyHoldState(evt.keyCode, false); ////
} ////

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

function handleMousedown(evt) {
  if(showingWinScreen) {
     paddle1Score = 0;
     paddle2Score = 0;
     showingWinScreen = false;
  }
}

function handleMousemove(evt) {
  if(twoPlayerMode == false) { ////
    var mousePos = calculateMousePos(evt);
    paddle1Y = mousePos.y - (PADDLE_HEIGHT/2); // minus half paddle height to center
  } ////
}

function setupInputEventHandlers() { //// changed from "mouse" to "input" - now has keyboard too
  canvas.addEventListener('mousedown', handleMousedown);
  canvas.addEventListener('mousemove', handleMousemove);
  document.addEventListener("keydown", keyPressed); ////
  document.addEventListener("keyup", keyReleased); ////
}