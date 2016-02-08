// save the canvas for dimensions, and its 2d context for drawing to it
var canvas, canvasContext;

const PLAYER_START_UNITS = 8;
var playerUnits = [];

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
        document.getElementById("debugText").innerHTML = "("+mousePos.x+","+mousePos.y+")";
      } );
  
  canvas.addEventListener('click', function(evt) {
        var mousePos = calculateMousePos(evt);
        for(var i=0;i<playerUnits.length;i++) {
          playerUnits[i].gotoNear(mousePos.x, mousePos.y); ////
        }
      } );
  
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
}