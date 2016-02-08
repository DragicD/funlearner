// save the canvas for dimensions, and its 2d context for drawing to it
var canvas, canvasContext;

var lassoX1 = 0;
var lassoY1 = 0;
var lassoX2 = 0;
var lassoY2 = 0;
var isMouseDragging = false;

const PLAYER_START_UNITS = 8;
var playerUnits = [];
var selectedUnits = [];
const MIN_DIST_TO_COUNT_DRAG = 10; ////

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

function mouseMovedEnoughToTreatAsDrag() { ////
  var deltaX = lassoX1-lassoX2; ////
  var deltaY = lassoY1-lassoY2; ////
  var dragDist = Math.sqrt(deltaX*deltaX + deltaY*deltaY); ////
  return ( dragDist > MIN_DIST_TO_COUNT_DRAG ); ////
} ////

window.onload = function() {
  canvas = document.getElementById('gameCanvas');
  canvasContext = canvas.getContext('2d');
  
  // these next few lines set up our game logic and render to happen 30 times per second
  var framesPerSecond = 30;
  setInterval(function() {
      moveEverything();
      drawEverything();
    }, 1000/framesPerSecond);
    
  canvas.addEventListener('mousemove', function(evt) {
        var mousePos = calculateMousePos(evt);
        if(isMouseDragging) {
          lassoX2 = mousePos.x;
          lassoY2 = mousePos.y;
        }
      } );
  
  canvas.addEventListener('mousedown', function(evt) {
        var mousePos = calculateMousePos(evt);
        lassoX1 = mousePos.x;
        lassoY1 = mousePos.y;
        lassoX2 = lassoX1;
        lassoY2 = lassoY1;
        isMouseDragging = true;
      } );

  canvas.addEventListener('mouseup', function(evt) {
        isMouseDragging = false;
        
        if(mouseMovedEnoughToTreatAsDrag()) { ////
          selectedUnits = []; // clear the selection array
  
          for(var i=0;i<playerUnits.length;i++) {
            if( playerUnits[i].isInBox(lassoX1,lassoY1,lassoX2,lassoY2) ) {
              selectedUnits.push(playerUnits[i]);
            }
          }
          document.getElementById("debugText").innerHTML = "Selected " + ////
                                        selectedUnits.length + " units"; ////
        } else { // mouse didn’t move far, treat as click for move command ////
          var mousePos = calculateMousePos(evt);
          for(var i=0;i<selectedUnits.length;i++) { ////
            selectedUnits[i].gotoNear(mousePos.x, mousePos.y); ////
          }
          document.getElementById("debugText").innerHTML = ////
                    "Moving to ("+mousePos.x+","+mousePos.y+")"; ////
        } ////
      } );

  //// removed 'click' listener, adapted its code into the 'mouseup' non-drag case
  
  for(var i=0;i<PLAYER_START_UNITS;i++) {
    var spawnUnit = new unitClass();
    spawnUnit.reset();
    playerUnits.push(spawnUnit);
  }
}

function moveEverything() {
  for(var i=0;i<playerUnits.length;i++) {
    playerUnits[i].move();
  }
}

function drawEverything() {
  // clear the game view by filling it with black
  colorRect(0, 0, canvas.width, canvas.height, 'black');
  
  for(var i=0;i<playerUnits.length;i++) {
    playerUnits[i].draw();
  }
  
  for(var i=0;i<selectedUnits.length;i++) {
    selectedUnits[i].drawSelectionBox();
  }
  
  if(isMouseDragging) {
    coloredOutlineRectCornerToCorner(lassoX1,lassoY1, lassoX2,lassoY2, 'yellow');
  }
}